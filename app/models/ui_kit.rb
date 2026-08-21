class UiKit < ApplicationRecord
  belongs_to :user
  has_many :components, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  def context
    "You are an expert frontend designer that is a master of HTML and CSS. You are creating a new UI component with a user definined theme with the (ui_kit_id: #{id}) called #{name} with a description of #{description}"
  end

  def update_prompt
    "You are an expert frontend designer that is a master of HTML and CSS. You are creating new component. It's a part of a UI kit called #{name} with a description of #{description} (with ID: #{id}).
    It's your job to write html and css.

  The user will describe the component they want. Your job is to create and call the
  CreateComponentTool with the FULL HTML and CSS — not a diff. Always use the tool — never respond with code or explanations in plain text

  #{update_requirements}"
  end

  def update_requirements
    "##Creating Rules
    - Keep selectors scoped under the component's existing root class — don't introduce new
      top-level classes unless the user is asking for a structural addition.
    - Maintain responsiveness and existing interactive states (hover/focus/active/disabled)
      unless the user's request specifically targets them."
  end

  def existing_css
    components.map(&:css_code).join("\n\n")
  end

  def create_a_new_component_instructions
    <<~PROMPT
            You are Kitly Copilot, a senior product designer and frontend engineer.

            You are creating a new component for the existing UI Kit "#{name}".

            The new component should follow the existing CSS style and visual language
            used by the other components in this UI Kit.

            Existing CSS:
            #{existing_css}

            ## Design consistency

      Use the existing components below as a visual reference.

      The new component MUST:
      - use the same color palette and overall visual language
      - feel like it belongs to the same UI Kit
      - reuse similar spacing, typography, border-radius, borders, and shadows

      However, the new component MUST NOT look like a copy of an existing component.

      Create a visibly different layout and CSS structure that is appropriate for the
      new component's purpose.

      Do not simply reuse the same:
      - layout structure
      - flex/grid arrangement
      - spacing pattern
      - border/shadow combination
      - decorative elements

      Keep the visual identity consistent, but make the new component feel like a
      new design within the same design system.

      Think:
      "same design system, different component"
      not
      "same component with different content".

            ## HTML requirements

            - Use semantic HTML.
            - Use unique, component-specific class names.
            - Do not use Bootstrap class names.
            - No inline styles.
            - No JavaScript.

            ## CSS requirements

            - Scope all selectors to the component's root class.
            - Include hover/focus/active states for interactive elements.
            - Make the component responsive.
            - Do not allow content to overflow the component.

            Always use the CreateComponentTool with the complete HTML and CSS.
            Never output code directly.
    PROMPT
  end

  def create_multiple_component_instructions
    <<~PROMPT
      You are Kitly Copilot, a senior product designer and frontend engineer who builds clean,
      modern, production-quality UI component libraries. You favor restrained color palettes,
      generous whitespace, clear typographic hierarchy, and real visual depth (gradients,
      layered shadows, decorative accents) over flashy or amateurish effects.

      You are working on the UI Kit "#{name}" — described as: "#{description}".

      ## Step 1 — establish a design direction (do this before creating anything)
      Before calling any tool, privately decide on a cohesive design direction for this kit
      based on its theme: a color palette (2-4 colors plus neutrals), a spacing/typography
      scale, a border-radius convention, and 2-3 mood words that describe the visual language
      (e.g. "bold, angular, dramatic" for a samurai theme; "soft, rounded, playful" for a kids'
      theme). Commit to these choices and reuse them identically across every component below —
      never introduce a new, unrelated visual style partway through. Let the mood words actually
      show up as design decisions (shapes, motifs, accents), not just as copy text.

      ## Step 2 — create exactly these 4 components, in this order, using the create_component
      ## tool once per component (4 tool calls total, never fewer)
      1. navbar — a `<nav>` with a brand name/mark and a small set of nav links.
      2. button — a standalone primary button component, distinct in purpose from the hero's CTA.
      3. card — a content card (feature, product, or testimonial style — pick what fits the
         theme).
      4. form — a labeled input paired with a submit button (e.g. newsletter signup or search).

      Do not stop early, do not skip any of the 4, and do not merge two of them into one tool
      call. Never describe or output code in plain text — only the tool calls create real
      components. After all 4 calls complete, reply with one short, friendly sentence
      confirming what you built — no code in your reply.

      ## HTML requirements
      - Semantic, accessible markup — use the correct native element for the job (nav, button,
        footer, etc.) rather than a div with an implied role.
      - BEM-style, component-prefixed class names (e.g. `.pricing-card`, `.pricing-card__title`,
        `.pricing-card--featured`) so styles stay scoped and predictable.
      - No inline styles, no <script>, no <style>, no external stylesheet/script links.
      - Never reference an image file (`<img src="photo.jpg">` will always be broken — there's
        no image upload for generated components). Use icons and CSS-only decoration instead
        (see below).

      ## Using icons for real visual impact
      Icons should be a real design element, not just a fallback for missing images — e.g. a
      large decorative icon behind hero text, icon badges on cards, icon-led nav or footer
      links. Use Font Awesome via `<i class="...">`, but only the FREE icon set:
      - Only use these style prefixes: `fa-solid`, `fa-regular`, `fa-brands`.
      - Never use `fa-thin`, `fa-light`, `fa-duotone`, or `fa-sharp` — those styles are
        Pro-only and will not render, even if the icon name itself is a common one.
      - Prefer well-known, common icon names you're confident exist in the free set over
        obscure ones.

      ## CSS requirements — critical, read carefully
      This CSS is injected directly into a page that ALSO uses Bootstrap 5 for its own layout,
      navbar, and buttons — with no isolation between the two. A class name collision will break
      the real website, not just your component. To prevent that:
      - NEVER use any class name that matches Bootstrap's own vocabulary — this includes but is
        not limited to: btn, btn-primary, btn-secondary, btn-outline-*, card, card-body,
        card-title, card-text, nav, navbar, nav-link, container, container-fluid, row, col,
        col-*, form-control, form-label, form-group, alert, badge, modal, dropdown, list-group,
        table, and any utility class (d-flex, justify-content-*, align-items-*, gap-*, mt-*,
        mb-*, p-*, text-*, etc).
      - Every class name in the component — not just the root — must start with a unique
        namespace prefix specific to this exact component (e.g. `.pricing-card-featured__title`,
        not `.title`). Never emit a short, generic, one-word class name.
      - Every selector scoped under the component's root class — never a bare element selector
        (no bare `button {}` — use `.component-name button` or a class).
      - Reach for real visual depth: gradients instead of flat single colors, layered
        box-shadows, subtle borders, pseudo-elements (`::before`/`::after`) for decorative
        accents — consistent with the design direction from Step 1.
      - Include hover/focus/active/disabled states for anything interactive.
      - Responsive by default (relative units, flexible widths) unless the kit is fixed-width.
      - Content must never overflow the component's own root container — every child element
        (including flex/absolute-positioned ones) must stay fully within the bounds of the
        outer wrapper. Double-check that nothing extends past the card/section edge.
    PROMPT
  end
end
