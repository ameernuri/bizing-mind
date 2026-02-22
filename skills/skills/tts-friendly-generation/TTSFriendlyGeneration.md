# TTS-Friendly Text Generation

> Convert any text content into spoken-word optimized format for text-to-speech systems.

## Purpose

Text-to-speech systems read text literally. Without optimization, technical content becomes unintelligible:
- "API" → "apee" or "appy"
- "JSON" → "jason" 
- "db:migrate" → "db colon migrate"
- "6129" → "six thousand one hundred twenty-nine" (bad) vs "six one two nine" (good for port numbers)

This skill converts written content into TTS-friendly format that sounds natural when spoken.

---

## Core Principles

### 1. Spell Out Acronyms

Convert uppercase acronyms to dot-separated letters:

| Written | TTS-Friendly |
|---------|-------------|
| API | A.P.I. |
| JSON | J.S.O.N. |
| URL | U.R.L. |
| HTTP | H.T.T.P. |
| SQL | S.Q.L. |
| KSUID | K.S.U.I.D. |
| UC | U.C. (use case) |
| DB | D.B. (database) |
| FK | F.K. (foreign key) |
| MCP | M.C.P. |
| TTS | T.T.S. |

**Exceptions:** Common words that TTS handles well:
- OK, USA, UK, NASA (keep as-is)
- AM, PM (keep as-is)

### 2. Format Numbers by Context

| Context | Written | TTS-Friendly |
|---------|---------|-------------|
| Port numbers | 6129 | six one two nine |
| IDs/timestamps | 20250222 | two zero two five zero two two two |
| Version numbers | v3 | version three |
| Percentages | 87% | eighty seven percent |
| Large counts | 210 | two hundred ten |
| Phone/style | 1-2-3 | one two three |
| Years | 2026 | twenty twenty six |
| Money | $50 | fifty dollars |

### 3. Convert Symbols to Words

| Symbol | TTS-Friendly |
|--------|-------------|
| / | slash |
| \ | backslash |
| : | colon |
| ; | semicolon |
| . | dot or period |
| , | comma |
| @ | at |
| # | hash or number |
| & | and |
| * | star or asterisk |
| - | dash or hyphen |
| _ | underscore |
| ~ | tilde |
| ` | backtick |
| \| | pipe |
| → | arrow or becomes |
| ✅ | checkmark or success |
| 🔴 | red circle or failure |
| 🎉 | celebration |

### 4. Format Paths and Commands

| Written | TTS-Friendly |
|---------|-------------|
| `~/projects/bizing` | tilde slash projects slash bizing |
| `db:migrate` | D.B. colon migrate |
| `npm install` | N.P.M. install |
| `localhost:6129` | localhost colon six one two nine |
| `agent-api-*.json` | agent-api-star dot json |
| `.env` | dot env |
| `package.json` | package dot json |
| `--full-auto` | dash dash full-auto |

### 5. Remove Markdown Formatting

Remove or convert:

| Markdown | TTS-Friendly |
|----------|-------------|
| `# Heading` | Heading. (or just the text) |
| `**bold**` | bold (no emphasis needed) |
| `*italic*` | italic |
| `` `code` `` | code |
| `[link](url)` | link |
| `\| table \|` | convert to list format |
| `- item` | item |
| `1. item` | one, item |
| `> quote` | quote |
| `---` | (remove or replace with pause) |

### 6. Structure for Spoken Flow

**Before:**
```
## Results

| UC | Rate |
|----|------|
| UC-1 | 100% |
| UC-2 | 80% |
```

**After:**
```
Results.

U.C. one, one hundred percent.
U.C. two, eighty percent.
```

### 7. Handle Technical Terms

| Term | TTS-Friendly |
|------|-------------|
| schema | schema |
| enum | E.N.U.M. or enum |
| SQL | S.Q.L. |
| Postgres | Postgres |
| migration | migration |
| constraint | constraint |
| fulfillment | fulfillment |
| orchestration | orchestration |
| pseudocode | pseudocode |
| CRUD | C.R.U.D. |
| REST | R.E.S.T. |
| SDK | S.D.K. |
| CLI | C.L.I. |
| UI | U.I. |
| UX | U.X. |

---

## Conversion Workflow

### Step 1: Read Source
Read the original markdown or text file.

### Step 2: Process Line by Line

For each line:
1. Remove markdown syntax
2. Convert acronyms to A.B.C. format
3. Convert symbols to words
4. Format numbers by context
5. Convert paths/commands
6. Simplify structure

### Step 3: Add Natural Pauses

- Replace `---` with paragraph break
- Replace bullet points with spoken lists
- Add periods where sentences end
- Use commas for natural breathing points

### Step 4: Review for Flow

Read aloud (mentally):
- Does it sound natural?
- Are technical terms clear?
- Are numbers readable?
- Are pauses in right places?

### Step 5: Output

Save as `.txt` with `-tts` suffix:
- `guide.md` → `guide-tts.txt`

---

## Example: Full Conversion

### Source (Markdown)

```markdown
## API Results

| Endpoint | Status |
|----------|--------|
| /api/v1/users | 200 OK |
| /api/v1/orders | 404 |

**Note:** Use `npm run dev` on localhost:3000.
```

### TTS-Friendly Output

```
A.P.I. Results.

Endpoint slash api slash v one slash users, status two hundred O.K.
Endpoint slash api slash v one slash orders, status four oh four.

Note. Use N.P.M. run dev on localhost colon three thousand.
```

---

## Common Pitfalls

### ❌ Don't
- Leave acronyms as-is (API, JSON)
- Use markdown tables
- Include code blocks with backticks
- Keep version numbers as digits (v3)
- Include emoji without conversion

### ✅ Do
- Spell out every acronym with dots
- Convert tables to spoken lists
- Replace backticks with "code" or remove
- Write "version three" not "v3"
- Convert emoji to descriptive words

---

## Quick Reference Card

### Acronyms (always convert)
- API → A.P.I.
- JSON → J.S.O.N.
- URL → U.R.L.
- HTTP → H.T.T.P.
- SQL → S.Q.L.
- DB → D.B.
- UC → U.C.
- FK → F.K.
- MCP → M.C.P.
- TTS → T.T.S.
- CRUD → C.R.U.D.
- REST → R.E.S.T.
- SDK → S.D.K.
- CLI → C.L.I.
- UI → U.I.
- UX → U.X.

### Symbols (always convert)
- / → slash
- : → colon
- . → dot or period
- @ → at
- & → and
- * → star
- - → dash
- _ → underscore

### Numbers (context-dependent)
- Ports: 6129 → six one two nine
- Versions: v3 → version three
- Percent: 100% → one hundred percent
- Years: 2026 → twenty twenty six
- IDs: spell digit by digit

---

## Tools

### Manual Conversion
Use this skill's principles line by line.

### Script-Assisted
Basic regex replacements can help:
- Find uppercase words 2-5 chars → add dots
- Find `:`` → replace with " colon "
- Find `/`` → replace with " slash "

But always human-review for context!

---

## Example Output Structure

```
Title of Document.

First section heading.

First paragraph with A.P.I. and J.S.O.N. spelled out. Use slash for paths like tilde slash projects.

Second section.

Bullet one.
Bullet two.
Bullet three.

Final thoughts with version three and one hundred percent success rate.
```

---

## Files Generated

When creating TTS versions:
- Original: `document.md`
- TTS: `document-tts.txt`
- Location: Same folder as original
- Encoding: UTF-8

---

## Quality Check

Before delivering TTS file:
- [ ] All acronyms have dots
- [ ] All symbols converted to words
- [ ] No markdown syntax remains
- [ ] Numbers formatted by context
- [ ] Paths readable as spoken words
- [ ] Structure flows naturally
- [ ] Read aloud test passed

---

**Remember:** The goal is content that sounds natural and clear when spoken by a TTS engine, not content that looks good on screen.
