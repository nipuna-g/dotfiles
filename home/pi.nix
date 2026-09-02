{ pkgs, ... }:

{
  home.file.".pi/agent/settings.json".text = builtins.toJSON {
    lastChangelogVersion = "0.84.2";
    theme = "dark";
    defaultProvider = "opencode";
    defaultModel = "gemini-3.5-flash";
    defaultThinkingLevel = "medium";
    packages = [
      "npm:pi-web-access"
    ];
  };

  home.file.".pi/agent/prompts/review-pr.md".text = ''
    ---
    description: Load and analyze a PR objectively, showing What/Why, and listing changes as atomic, chronological construction steps.
    argument-hint: "<PR-URL-or-ID-or-local>"
    ---
    Please assist me in understanding the specified pull request/code changes: `''${1:-local}`

    ### Your Objective
    Help me build an accurate mental model of what is being changed and why, without giving subjective opinions, design critiques, or review comments.

    ### Instructions:
    1. **Gather PR Context & Diff:**
       - If a PR URL/ID is given (not "local"), use the `bash` tool to run `gh pr view $1` to see the title and description, and `gh pr diff $1` to view the changes.
       - If "local" is specified or implied, get the diff against the target branch (e.g., `git diff origin/main...HEAD` or `git diff main...HEAD`).
       - If there are Jira tickets, Confluence links, or design docs mentioned in the PR description, use `fetch_content` (or curl/web-search if needed) to pull their details to understand the business context.

    2. **Synthesize the Analysis (Keep it Concise!):**
       - **What & Why:** Provide 1-2 concise bullet points explaining the core change and the technical/business motivation (referencing the PR or tickets).
       - **Atomic Construction Steps:** Chronologically reconstruct the changes as a series of **atomic, logical construction steps** (how you would build this from scratch).
         - Each step must be a single cohesive architectural or implementation action (e.g., "Step 1: Add new data models and migrations", "Step 2: Add database access functions", "Step 3: Implement route handler", "Step 4: Hook up routes in server", "Step 5: Write unit tests").
         - List the key files modified/created for each step.

    3. **Rules:**
       - **Strictly Objective:** Do not suggest style changes, criticize the implementation, or leave "PR feedback" yet. Keep it completely descriptive.
       - **Concise:** Minimize text; don't give me wall-of-text explanations.

    4. **Provide Next Steps:**
       - Invite me to:
         - Deep dive into any step using `/step <number>` to see the specific code and an explanation.
         - Ask clarifying questions about Confluence docs, architecture, or other repos.
  '';

  home.file.".pi/agent/prompts/step.md".text = ''
    ---
    description: Focus on a single atomic construction step, showing code and an objective walk-through.
    argument-hint: "<step-number>"
    ---
    Let's deep dive into **Step $1** from our atomic reconstruction of the PR changes.

    1. **Code walkthrough:** Find and show the exact, relevant blocks of code added or modified in this specific step.
    2. **How it works:** Provide a 1-2 sentence objective explanation of this step's implementation.
    3. **Dependencies:** Briefly mention if this step relies on previous steps or has dependencies on external modules/libraries.

    Remember: Do not add any subjective opinions or critique. Keep it strictly descriptive and educational.
  '';

  home.file.".pi/agent/skills/code-review-helper/SKILL.md".text = ''
    ---
    name: code-review-helper
    description: Guides the agent on how to pull Pull Request diffs, view Jira/Confluence context, and break down code modifications into atomic, step-by-step reconstructions for a human.
    ---

    # Code Review Helper Skill

    Use this skill when the user asks to review or understand a Pull Request, git branch, diff, or specific set of changes.

    ## Context Retrieval Workflows

    ### 1. Retrieving Pull Requests (GitHub CLI)
    When a PR ID or URL is provided, run:
    ```bash
    gh pr view <pr-id-or-url>
    gh pr diff <pr-id-or-url>
    ```
    If `gh` is not authenticated or not available, falls back to inspecting local git branches or git history.

    ### 2. Loading External Context (Confluence / Jira / Docs)
    Identify external links in the description. Use the `fetch_content` tool to read the markdown/text from those URLs, or use curl inside `bash`. Incorporate these to understand:
    - Business logic / requirement rationale.
    - Expected inputs, outputs, or schemas.

    ## Representation Guidelines (The "Atomic Reconstruction" Format)

    Instead of reviewing code file-by-file or line-by-line (which is hard for humans to follow), reconstruct the implementation **chronologically and incrementally**:

    1. **Define the Foundation:** (e.g. data models, configurations, types).
    2. **Implement Core Logic:** (e.g. database layers, services, utilities).
    3. **Hook up Interfaces:** (e.g. controllers, route handlers, UI components).
    4. **Register / Integrate:** (e.g. register routes, hook up event listeners).
    5. **Test & Verify:** (e.g. unit/integration tests).

    ## Interaction Rules

    - **Zero Critique:** Unless explicitly asked to point out bugs or suggest improvements, do not leave "opinions" or review comments. Focus purely on helping the human comprehend.
    - **Conciseness is King:** Avoid long preambles. Output headings, short lists, and let the user request further expansion.
  '';
}
