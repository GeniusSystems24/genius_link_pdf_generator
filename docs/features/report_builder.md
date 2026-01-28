# Report Builder with Split Tables & Text

**Version:** 1.1.0  
**Status:** 🔜 Planned (Priority #1)  
**Priority:** 🔴 High

---

## Overview

Create a powerful Report Builder that supports mixed content layouts with interspersed text paragraphs and tables. This feature enables generating professional reports with flowing content that naturally combines descriptive text, data tables, notes, and sections.

---

## Use Case

### Example Scenario

```
As a business user,
I want to create reports with mixed content (text and tables),
So that I can generate comprehensive documents like invoices, 
financial reports, and data summaries.
```

### Target Output

```
┌─────────────────────────────────────────────────────────────────┐
│                       Report Title                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  This is a descriptive paragraph about the content that         │
│  follows. It provides some context or introduction to the       │
│  data presented in the tables below.                            │
│                                                                  │
│  ┌────────────┬────────────┬────────────┐                       │
│  │ Header 1   │ Header 2   │ Header 3   │                       │
│  ├────────────┼────────────┼────────────┤                       │
│  │ Data 1-1   │ Data 1-2   │ Data 1-3   │                       │
│  │ Data 2-1   │ Data 2-2   │ Data 2-3   │                       │
│  │ ...        │ ...        │ ...        │                       │
│  └────────────┴────────────┴────────────┘                       │
│                                                                  │
│  # Another Section's Headline                                    │
│                                                                  │
│  Here's another table with different but related data.          │
│                                                                  │
│  ┌────────────┬────────────┬────────────┐                       │
│  │ Category   │ Value      │ Status     │                       │
│  ├────────────┼────────────┼────────────┤                       │
│  │ Alpha      │ 100        │ Active     │                       │
│  │ Beta       │ 200        │ Inactive   │                       │
│  └────────────┴────────────┴────────────┘                       │
│                                                                  │
│  *Note: This is important information or disclaimer.*           │
│                                                                  │
│  ┌────────────┬────────────┬────────────┐                       │
│  │ Item       │ Quantity   │ Unit       │                       │
│  ├────────────┼────────────┼────────────┤                       │
│  │ Pen        │ 5          │ pcs        │                       │
│  │ Paper      │ 1          │ ream       │                       │
│  └────────────┴────────────┴────────────┘                       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Requirements

### Functional Requirements

1. **Mixed Content Flow**
   - Seamlessly alternate between text paragraphs and tables
   - Automatic Y-position tracking after each element
   - Support for headings, paragraphs, notes, and tables

2. **Text Elements**
   - Headings (H1, H2, H3 styles)
   - Paragraphs with automatic text wrapping
   - Notes/disclaimers (italic, smaller text)
   - Bullet points and numbered lists

3. **Table Elements**
   - Simple table creation from data
   - Header row styling
   - Auto-sizing columns
   - Cell alignment options
   - Border styles

4. **Page Flow**
   - Automatic page breaks when content exceeds page
   - Tables split across pages with repeated headers
   - Orphan/widow control for text

5. **Styling**
   - Consistent styling throughout report
   - Customizable spacing between elements
   - RTL support for Arabic/Hebrew reports

---

## API Design

### Basic Report Builder

```dart
class SalesReportBuilder extends PdfDocumentBuilder {
  final List<SalesData> salesData;
  final List<CategoryData> categoryData;
  final List<InventoryItem> inventory;

  SalesReportBuilder({
    required PdfConfig config,
    required this.salesData,
    required this.categoryData,
    required this.inventory,
  }) : super(config);

  @override
  void build() {
    addHeader(title: 'Sales Report');

    // Section 1: Introduction with table
    addHeading('Monthly Sales Overview', level: 1);
    
    addParagraph(
      'This is a descriptive paragraph about the content that follows. '
      'It provides some context or introduction to the data presented '
      'in the tables below.',
    );

    addTable(
      headers: ['Header 1', 'Header 2', 'Header 3'],
      rows: salesData.map((s) => [s.col1, s.col2, s.col3]).toList(),
      style: PdfTableStyle(
        headerBackground: Colors.blue[700],
        headerTextColor: Colors.white,
        alternatingRows: true,
      ),
    );

    // Section 2: Another section with different table
    addHeading("Another Section's Headline", level: 1);
    
    addParagraph(
      "Here's another table, perhaps presenting different but related data.",
    );

    addTable(
      headers: ['Category', 'Value', 'Status'],
      rows: categoryData.map((c) => [c.category, c.value, c.status]).toList(),
    );

    // Note
    addNote(
      'Note: This is an important piece of information or a disclaimer '
      'related to the content above.',
    );

    // Another table
    addTable(
      headers: ['Item', 'Quantity', 'Unit'],
      rows: inventory.map((i) => [i.name, i.qty, i.unit]).toList(),
    );

    addFooter(showPageNumber: true);
  }
}
```

### Content Methods

```dart
// Headings
void addHeading(String text, {int level = 1, PdfFont? font});

// Paragraphs
void addParagraph(String text, {
  double topMargin = 10,
  double bottomMargin = 10,
  PdfFont? font,
  TextAlign? align,
});

// Notes/Disclaimers
void addNote(String text, {PdfFont? font, Color? color});

// Bullet Lists
void addBulletList(List<String> items, {String bullet = '•'});

// Numbered Lists
void addNumberedList(List<String> items, {int startNumber = 1});

// Tables
void addTable({
  required List<String> headers,
  required List<List<dynamic>> rows,
  PdfTableStyle? style,
  List<double>? columnWidths,
  bool repeatHeaderOnNewPage = true,
});

// Spacing
void addSpace(double height);
void addPageBreak();
```

### Table Style

```dart
class PdfTableStyle {
  final Color? headerBackground;
  final Color? headerTextColor;
  final PdfFont? headerFont;
  final Color? rowBackground;
  final Color? alternatingRowColor;
  final bool alternatingRows;
  final double borderWidth;
  final Color? borderColor;
  final EdgeInsets cellPadding;
  final List<TextAlign>? columnAlignments;
}
```

---

## Implementation Plan

### Phase 1: Core Content Methods

1. Implement `addParagraph()` with text wrapping
2. Implement `addHeading()` with level styling
3. Implement `addNote()` for special text
4. Position tracking after each element

### Phase 2: Table Implementation

1. Basic table with headers and rows
2. Header styling
3. Cell padding and alignment
4. Border styling
5. Auto column width calculation

### Phase 3: Page Flow

1. Automatic page breaks
2. Table continuation across pages
3. Header repetition on new pages
4. Proper spacing management

### Phase 4: Advanced Features

1. Bullet and numbered lists
2. RTL table support
3. Column spanning
4. Row spanning

---

## Example Usage

### Complete Report Example

```dart
final report = SalesReportBuilder(
  config: PdfConfig(
    baseFont: PdfTrueTypeFont(PdfAssets.instance.primaryFont, 12),
    textDirection: TextDirection.ltr,
  ),
  salesData: [
    SalesData('Data 1-1', 'Data 1-2', 'Data 1-3'),
    SalesData('Data 2-1', 'Data 2-2', 'Data 2-3'),
    // ... more rows
    SalesData('Data 15-1', 'Data 15-2', 'Data 15-3'),
  ],
  categoryData: [
    CategoryData('Alpha', '100', 'Active'),
    CategoryData('Beta', '200', 'Inactive'),
  ],
  inventory: [
    InventoryItem('Pen', '5', 'pcs'),
    InventoryItem('Paper', '1', 'ream'),
  ],
);

final service = PdfService();
await service.generateAndOpen(
  builder: report,
  fileName: 'sales_report',
);
```

---

## Test Cases

- [ ] Single paragraph renders correctly
- [ ] Multiple paragraphs with proper spacing
- [ ] Heading levels (H1, H2, H3) with correct styling
- [ ] Basic table with headers
- [ ] Table with alternating row colors
- [ ] Mixed content: paragraph → table → paragraph → table
- [ ] Long table spanning multiple pages
- [ ] Header repetition on new page
- [ ] Note text with italic style
- [ ] Bullet list rendering
- [ ] Numbered list rendering
- [ ] RTL report with Arabic text
- [ ] RTL table with proper alignment
- [ ] Page break before table if not enough space
- [ ] Empty table handling
- [ ] Very long paragraph text wrapping

---

## Timeline

| Task | Duration | Status |
|------|----------|--------|
| Core content methods | 3 days | ⏳ Pending |
| Basic table implementation | 4 days | ⏳ Pending |
| Table styling | 2 days | ⏳ Pending |
| Page flow handling | 3 days | ⏳ Pending |
| RTL support | 2 days | ⏳ Pending |
| Testing | 2 days | ⏳ Pending |
| Documentation | 1 day | ⏳ Pending |

**Total:** ~17 days

---

## Success Criteria

1. Can create reports matching the example output above
2. Tables and text flow naturally together
3. Automatic page breaks work correctly
4. RTL reports work properly
5. Clean, intuitive API

---

*Created: December 2024*
