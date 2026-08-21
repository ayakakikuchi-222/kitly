class UiKitsController < ApplicationController
  before_action :set_ui_kit, only: [:destroy]

  def show
    @ui_kit = current_user.ui_kits.find(params[:id])
    @message = Message.new
    @components_by_category = @ui_kit.components.group_by(&:category)
  end

  def index
    @ui_kits = current_user.ui_kits.order(:created_at)
    @ui_kit = current_user.ui_kits.new
  end

  def create
    @ui_kit = current_user.ui_kits.new
    ask_llm_to_set_ui_kit_details(params[:theme_prompt])

    if @ui_kit.save
      # ask_llm_to_create_component
      CreateKitJob.perform_later(@ui_kit)
      redirect_to ui_kit_path(@ui_kit), notice: "UI Kit was successfully created!"
    else
      redirect_to ui_kits_path, alert: @ui_kit.errors.full_messages.to_sentence
    end
  end

  def destroy
    @ui_kit.destroy
    redirect_to ui_kits_path, notice: "UI Kit was successfully deleted.", status: :see_other
  end

  private

  def set_ui_kit
    @ui_kit = current_user.ui_kits.find(params[:id])
  end

  def ask_llm_to_set_ui_kit_details(theme_prompt)
    ruby_llm_chat = RubyLLM.chat(model: "gpt-4.1-mini")
    ruby_llm_chat.with_tool(SetUiKitDetailsTool.new(ui_kit: @ui_kit))
    ruby_llm_chat.with_instructions(set_ui_kit_details_instructions)

    ruby_llm_chat.ask(theme_prompt)
  end

  def set_ui_kit_details_instructions
    <<~PROMPT
      You are Kitly Copilot, helping a user set up a new UI Kit. The user will describe, in
      their own words, what kind of website they're creating.

      Call the set_ui_kit_details tool exactly once with:
      - name: a short, catchy name for the UI kit (a few words).
      - description: a one-to-two sentence description of the kit's visual theme and purpose,
        written so it can guide another designer building components for it.
    PROMPT
  end

  def ask_llm_to_create_component
    ruby_llm_chat = RubyLLM.chat(model: "gpt-4.1-mini")
    ruby_llm_chat.with_tool(CreateComponentTool.new(ui_kit: @ui_kit))
    ruby_llm_chat.with_instructions(create_component_instructions)

    ruby_llm_chat.ask(@ui_kit.description)
  end

  # 6. footer — a `<footer>` with a few links/icons and short copyright text.
  # 2. hero — a prominent banner section: heading, supporting text, and a call-to-action
  # button, with a decorative background treatment (gradient, pattern, or large background
  # icon) that reflects the theme.

  # def create_component_instructions
  #   <<~PROMPT
  #     You are Kitly Copilot, a senior product designer and frontend engineer who builds clean,
  #     modern, production-quality UI component libraries. You favor restrained color palettes,
  #     generous whitespace, clear typographic hierarchy, and real visual depth (gradients,
  #     layered shadows, decorative accents) over flashy or amateurish effects.

  #     You are working on the UI Kit "#{@ui_kit.name}" — described as: "#{@ui_kit.description}".

  #     ## Step 1 — establish a design direction (do this before creating anything)
  #     Before calling any tool, privately decide on a cohesive design direction for this kit
  #     based on its theme: a color palette (2-4 colors plus neutrals), a spacing/typography
  #     scale, a border-radius convention, and 2-3 mood words that describe the visual language
  #     (e.g. "bold, angular, dramatic" for a samurai theme; "soft, rounded, playful" for a kids'
  #     theme). Commit to these choices and reuse them identically across every component below —
  #     never introduce a new, unrelated visual style partway through. Let the mood words actually
  #     show up as design decisions (shapes, motifs, accents), not just as copy text.

  #     ## Step 2 — create exactly these 4 components, in this order, using the create_component
  #     ## tool once per component (4 tool calls total, never fewer)
  #     1. navbar — a `<nav>` with a brand name/mark and a small set of nav links.
  #     2. button — a standalone primary button component, distinct in purpose from the hero's CTA.
  #     3. card — a content card (feature, product, or testimonial style — pick what fits the
  #        theme).
  #     4. form — a labeled input paired with a submit button (e.g. newsletter signup or search).

  #     Do not stop early, do not skip any of the 4, and do not merge two of them into one tool
  #     call. Never describe or output code in plain text — only the tool calls create real
  #     components. After all 4 calls complete, reply with one short, friendly sentence
  #     confirming what you built — no code in your reply.

  #     ## HTML requirements
  #     - Semantic, accessible markup — use the correct native element for the job (nav, button,
  #       footer, etc.) rather than a div with an implied role.
  #     - BEM-style, component-prefixed class names (e.g. `.pricing-card`, `.pricing-card__title`,
  #       `.pricing-card--featured`) so styles stay scoped and predictable.
  #     - No inline styles, no <script>, no <style>, no external stylesheet/script links.
  #     - Never reference an image file (`<img src="photo.jpg">` will always be broken — there's
  #       no image upload for generated components). Use icons and CSS-only decoration instead
  #       (see below).

  #     ## Using icons for real visual impact
  #     Icons should be a real design element, not just a fallback for missing images — e.g. a
  #     large decorative icon behind hero text, icon badges on cards, icon-led nav or footer
  #     links. Use Font Awesome via `<i class="...">`, but only the FREE icon set:
  #     - Only use these style prefixes: `fa-solid`, `fa-regular`, `fa-brands`.
  #     - Never use `fa-thin`, `fa-light`, `fa-duotone`, or `fa-sharp` — those styles are
  #       Pro-only and will not render, even if the icon name itself is a common one.
  #     - Prefer well-known, common icon names you're confident exist in the free set over
  #       obscure ones.

  #     ## CSS requirements — critical, read carefully
  #     This CSS is injected directly into a page that ALSO uses Bootstrap 5 for its own layout,
  #     navbar, and buttons — with no isolation between the two. A class name collision will break
  #     the real website, not just your component. To prevent that:
  #     - NEVER use any class name that matches Bootstrap's own vocabulary — this includes but is
  #       not limited to: btn, btn-primary, btn-secondary, btn-outline-*, card, card-body,
  #       card-title, card-text, nav, navbar, nav-link, container, container-fluid, row, col,
  #       col-*, form-control, form-label, form-group, alert, badge, modal, dropdown, list-group,
  #       table, and any utility class (d-flex, justify-content-*, align-items-*, gap-*, mt-*,
  #       mb-*, p-*, text-*, etc).
  #     - Every class name in the component — not just the root — must start with a unique
  #       namespace prefix specific to this exact component (e.g. `.pricing-card-featured__title`,
  #       not `.title`). Never emit a short, generic, one-word class name.
  #     - Every selector scoped under the component's root class — never a bare element selector
  #       (no bare `button {}` — use `.component-name button` or a class).
  #     - Reach for real visual depth: gradients instead of flat single colors, layered
  #       box-shadows, subtle borders, pseudo-elements (`::before`/`::after`) for decorative
  #       accents — consistent with the design direction from Step 1.
  #     - Include hover/focus/active/disabled states for anything interactive.
  #     - Responsive by default (relative units, flexible widths) unless the kit is fixed-width.
  #     - Content must never overflow the component's own root container — every child element
  #       (including flex/absolute-positioned ones) must stay fully within the bounds of the
  #       outer wrapper. Double-check that nothing extends past the card/section edge.
  #   PROMPT
  # end
end
