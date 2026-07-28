Pywal colors follow the standard 16-color terminal palette:

| Color     | Name           | Typical Use                 |
| --------- | -------------- | --------------------------- |
| `color0`  | Black          | Background, dark elements   |
| `color1`  | Red            | Errors, deletions, warnings |
| `color2`  | Green          | Success, additions, strings |
| `color3`  | Yellow         | Warnings, classes, types    |
| `color4`  | Blue           | Info, functions, links      |
| `color5`  | Magenta        | Keywords, special items     |
| `color6`  | Cyan           | Constants, includes         |
| `color7`  | White          | Foreground text             |
| `color8`  | Bright Black   | Comments, muted text        |
| `color9`  | Bright Red     | Bright errors               |
| `color10` | Bright Green   | Bright strings              |
| `color11` | Bright Yellow  | Bright warnings             |
| `color12` | Bright Blue    | Bright functions            |
| `color13` | Bright Magenta | Bright keywords             |
| `color14` | Bright Cyan    | Bright constants            |
| `color15` | Bright White   | Bold/bright text            |

Here's a comprehensive color reference from that pywal16 highlight file:

"#fafafa",
"#f5f5f5",
"#f0f0f0",
"#ebebeb",
"#e0e0e0"
"#cccccc", -- lightest
"#999999",
"#666666", -- mid
"#404040",
"#1a1a1a", -- darkest

- color3 constants, highlight visual
- color5 methods
- color5 methods
- color6 strings
- color8 numbers

## Color Usage Summary

| Color        | Role               | Used For                                                                                  |
| ------------ | ------------------ | ----------------------------------------------------------------------------------------- |
| `color1`     | **Muted/Comments** | Comments, line numbers, borders, non-text, indent guides                                  |
| `color2`     | **Success/Add**    | Spell bad, special comments, tabs, folder icons, pmenu thumb                              |
| `color3`     | **Danger**         | Warnings, TS danger highlights                                                            |
| `color4`     | Primary/Info       | Directories, search, diff add, git add, titles, labels, health success, links, properties |
| `color5`     | Accent/Variables   | Constants, numbers, variables, identifiers, diff change, git change, types, TS parameters |
| `color6`     | Keywords/Functions | Functions, operators, keywords, statements, includes, macros, structure, constructors     |
| `color7`     | **Neutral/Text**   | Storage class, labels, operators, punctuation, delimiters, regex                          |
| `color8`     | **References**     | Text references                                                                           |
| `color9`     | **Line numbers**   | LineNr                                                                                    |
| `color11`    | **Errors/Delete**  | Errors, debug, todo, diff delete, git delete, variable builtin                            |
| `color12`    | **Strings/Fields** | Strings, characters, TS fields                                                            |
| `background` | **Background**     | All backgrounds                                                                           |
| `foreground` | **Foreground**     | Main text, delimiters, brackets                                                           |
| `cursor`     | **Cursor**         | All cursor variants                                                                       |
