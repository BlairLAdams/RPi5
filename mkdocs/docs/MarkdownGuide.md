
# Markdown Quick Guide

This guide provides a quick reference for using Markdown in MkDocs.

---

## Headings

Use `#` for headers, increasing the number for lower levels:

```markdown
# H1
## H2
### H3
#### H4
##### H5
###### H6
```

---

## Emphasis

```markdown
*Italic* or _Italic_

**Bold** or __Bold__

***Bold Italic***

~~Strikethrough~~
```

---

## Lists

### Unordered List

```markdown
- Item 1
- Item 2
  - Nested Item
* Another bullet
```

### Ordered List

```markdown
1. First
2. Second
   1. Sub-item
```

---

## Links

```markdown
[Example Link](https://example.com)

[Link with Title](https://example.com "Optional Title")
```

---

## Images

```markdown
![Alt text](https://example.com/image.png "Optional Title")
```

_Local images should be in the same directory or a path relative to the `docs/` folder._

---

## Inline Code and Code Blocks

### Inline Code

Use single backticks: `` `code` ``

### Code Block

\`\`\`python
# Example
print("Hello, MkDocs!")
\`\`\`

---

## Blockquotes

```markdown
> A simple quote

>> Nested quote
```

---

## Horizontal Rule

```markdown
---
```

---

## Tables

```markdown
| Header 1 | Header 2 |
|----------|----------|
| Cell 1   | Cell 2   |
| Cell 3   | Cell 4   |
```

---

## Task Lists

GitHub-style task lists (works in MkDocs with Material theme):

```markdown
- [x] Task complete
- [ ] Task incomplete
```

---

## Admonitions

Use for notes, warnings, tips, etc. (Material theme only):

```markdown
!!! note
    This is a note.

!!! warning
    This is a warning box.
```

---

## Collapsible Sections

```markdown
<details>
<summary>Click to expand</summary>

This text is hidden until expanded.

</details>
```

---

## HTML in Markdown

Inline HTML is supported in most engines:

```html
<sup>Superscript</sup> <kbd>Ctrl</kbd>+<kbd>C</kbd>
```

---

## Escaping Characters

Use `\` to escape special characters:

```markdown
\*Not italic\*
```

---

## Footnotes (if supported)

```markdown
Here's a statement.[^1]

[^1]: This is a footnote.
```

---

## Resources

- CommonMark Help: https://commonmark.org/help/
- GitHub Markdown Guide: https://guides.github.com/features/mastering-markdown/
- MkDocs Material Docs: https://squidfunk.github.io/mkdocs-material/