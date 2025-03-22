# Contributing to DJ Tools  

Thank you for your interest in contributing to **[DJ Tools**](https://www.github.com/ryandils/dj-tools)! This project follows **[trunk-based development]**(https://trunkbaseddevelopment.com/), ensuring a streamlined workflow and rapid iteration. Please read the following guidelines before making a contribution.

## 📌 Trunk-Based Development Rules  

1. **Work Directly on `master` or Use Short-Lived Feature Branches**  
   - All commits should be made directly to `main` if they are small, safe, and incremental.  
   - For larger changes, create a **short-lived feature branch**, merge it as soon as possible, and delete the branch.  

2. **Keep Changes Small & Frequent**  
   - Commit and push small, self-contained changes frequently to avoid merge conflicts.  
   - Avoid long-lived feature branches or large pull requests (PRs).  

3. **Feature Flags for Risky Changes**  
   - If a change is experimental, wrap it in a **feature flag** to avoid breaking existing functionality.  

4. **Rebasing Over Merging**  
   - If you are working on a feature branch, **rebase with `main`** before merging to ensure a clean commit history.  

5. **Write Meaningful Commit Messages**  
   - Use clear, concise commit messages following this format:  
     ```
     [Component] Short description of the change  
     ```
     Example:  
     ```
     [Library] Add script for detecting duplicate tracks  
     ```

6. **Pull Request Guidelines**  
   - All PRs should be small, with **clear descriptions** of the problem being solved.  
   - Include relevant **documentation updates** in `docs/` if applicable.  
   - PRs should be reviewed and merged quickly to maintain a fast-moving trunk.  

7. **Code Review & Approval**  
   - Code should be reviewed by at least one other contributor before merging.  
   - Self-merging is allowed for minor changes (e.g., typo fixes).  

8. **Automated Testing & Linting**  
   - Ensure your code passes all **tests and lint checks** before submitting a PR.  
   - Use existing test scripts or add new ones if needed.  

9. **Documentation Updates**  
   - If your changes affect functionality, update relevant documentation in the `docs/` folder.  

10. **Avoid Unnecessary Dependencies**  
   - Prefer built-in tools and libraries over adding new dependencies unless absolutely necessary.  
