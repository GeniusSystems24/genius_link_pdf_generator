# Tables & Grids Feature

**Version:** 1.1.0  
**Status:** 🔜 Planned  
**Priority:** High

---

## Overview

Add comprehensive table and grid support for creating structured data layouts in PDF documents.

---

## Requirements

### Functional Requirements

1. **Table Creation**
   - Create tables with headers and data rows
   - Support for column widths (fixed, percentage, auto)
   - Cell alignment (left, center, right)
   - Text wrapping within cells

2. **Styling**
   - Header background color
   - Alternating row colors (zebra striping)
   - Border styles (solid, dashed, none)
   - Cell padding and margins
   - Font customization per cell

3. **Advanced Features**
   - Column spanning (merge cells horizontally)
   - Row spanning (merge cells vertically)
   - Nested tables
   - Page break handling (repeat headers)

### Non-Functional Requirements

- Performance: Handle 1000+ rows efficiently
- Memory: Stream large tables without loading all in memory
- RTL: Full support for right-to-left tables

---

## API Design

### Basic Table

```dart
// Simple table with headers and rows
addTable(
  headers: ['Name', 'Quantity', 'Price'],
  rows: [
    ['Product A', '10', '\$100'],
    ['Product B', '5', '\$50'],
  ],
);
```

### Styled Table

```dart
addTable(
  headers: ['Name', 'Quantity', 'Price'],
  rows: data,
  style: PdfTableStyle(
    headerStyle: PdfCellStyle(
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    rowStyle: PdfCellStyle(
      padding: EdgeInsets.all(8),
    ),
    alternatingRowColor: Colors.grey[100],
    borderColor: Colors.grey,
    borderWidth: 0.5,
  ),
);
```

### Column Configuration

```dart
addTable(
  columns: [
    PdfTableColumn(
      header: 'Product',
      width: PdfColumnWidth.flex(2),
      alignment: PdfTextAlignment.left,
    ),
    PdfTableColumn(
      header: 'Qty',
      width: PdfColumnWidth.fixed(50),
      alignment: PdfTextAlignment.center,
    ),
    PdfTableColumn(
      header: 'Price',
      width: PdfColumnWidth.percentage(20),
      alignment: PdfTextAlignment.right,
    ),
  ],
  rows: data,
);
```

### Cell Spanning

```dart
addTable(
  rows: [
    [
      PdfTableCell(text: 'Merged Header', columnSpan: 3),
    ],
    ['Col 1', 'Col 2', 'Col 3'],
    [
      PdfTableCell(text: 'Tall Cell', rowSpan: 2),
      'Row 1 Col 2',
      'Row 1 Col 3',
    ],
    ['Row 2 Col 2', 'Row 2 Col 3'],
  ],
);
```

---

## Classes

### PdfTable

```dart
class PdfTable {
  final List<PdfTableColumn> columns;
  final List<PdfTableRow> rows;
  final PdfTableStyle style;
  final bool repeatHeaderOnNewPage;
}
```

### PdfTableColumn

```dart
class PdfTableColumn {
  final String header;
  final PdfColumnWidth width;
  final PdfTextAlignment alignment;
  final PdfCellStyle? headerStyle;
  final PdfCellStyle? cellStyle;
}
```

### PdfTableCell

```dart
class PdfTableCell {
  final String text;
  final int columnSpan;
  final int rowSpan;
  final PdfCellStyle? style;
  final Widget? child; // For complex content
}
```

### PdfTableStyle

```dart
class PdfTableStyle {
  final PdfCellStyle? headerStyle;
  final PdfCellStyle? rowStyle;
  final Color? alternatingRowColor;
  final Color? borderColor;
  final double borderWidth;
  final PdfTableBorderStyle borderStyle;
}
```

---

## Implementation Notes

1. Use Syncfusion's `PdfGrid` as the underlying implementation
2. Create wrapper classes for easier API
3. Handle automatic page breaks with header repetition
4. Support both String and Widget cell content
5. Calculate column widths based on content if auto

---

## Test Cases

- [ ] Basic table with headers
- [ ] Table with styling
- [ ] Column spanning
- [ ] Row spanning
- [ ] Long table with page breaks
- [ ] RTL table
- [ ] Empty table
- [ ] Single row/column table
- [ ] Table with images in cells

---

## Dependencies

- No additional dependencies required
- Uses existing Syncfusion PDF grid

---

## Timeline

| Task | Duration | Status |
|------|----------|--------|
| API Design | 2 days | ✅ Done |
| Core Implementation | 5 days | ⏳ Pending |
| Styling Support | 3 days | ⏳ Pending |
| Cell Spanning | 2 days | ⏳ Pending |
| Testing | 2 days | ⏳ Pending |
| Documentation | 1 day | ⏳ Pending |

**Total:** ~15 days

---

*Created: December 2024*
