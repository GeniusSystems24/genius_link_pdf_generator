# Future Features Roadmap

This document outlines planned features and improvements for the `genius_link_pdf_generator` package.

---

## 📋 Table of Contents

- [v1.1.0 - Report Builder & Tables](#v110---report-builder--tables)
- [v1.2.0 - Charts & Graphics](#v120---charts--graphics)
- [v1.3.0 - Forms & Interactive](#v130---forms--interactive)
- [v1.4.0 - Advanced Templates](#v140---advanced-templates)
- [v2.0.0 - Major Enhancements](#v200---major-enhancements)
- [Backlog](#backlog)

---

## v1.1.0 - Report Builder & Tables

**Status:** 🔜 Planned  
**Target:** Q1 2025

### 🌟 Priority #1: Report Builder with Split Tables & Text

Create professional reports with mixed content - seamlessly combining text paragraphs, headings, notes, and data tables in a flowing document layout.

📄 **[Full Specification](./features/report_builder.md)**

#### Key Features

| Feature | Description | Priority |
|---------|-------------|----------|
| Mixed Content | Alternate between paragraphs and tables | 🔴 High |
| `addParagraph()` | Text with automatic wrapping | 🔴 High |
| `addHeading()` | H1, H2, H3 heading styles | 🔴 High |
| `addTable()` | Tables with headers, rows, styling | 🔴 High |
| `addNote()` | Italic notes/disclaimers | 🟡 Medium |
| Page Flow | Auto page breaks, table continuation | 🟡 Medium |

#### Example Output

```
┌─────────────────────────────────────────────────────┐
│  # Report Title                                      │
│                                                      │
│  This is a descriptive paragraph about the content  │
│  that follows...                                     │
│                                                      │
│  ┌────────────┬────────────┬────────────┐           │
│  │ Header 1   │ Header 2   │ Header 3   │           │
│  ├────────────┼────────────┼────────────┤           │
│  │ Data 1-1   │ Data 1-2   │ Data 1-3   │           │
│  │ Data 2-1   │ Data 2-2   │ Data 2-3   │           │
│  └────────────┴────────────┴────────────┘           │
│                                                      │
│  # Another Section                                   │
│                                                      │
│  Here's another table with different data...        │
│                                                      │
│  ┌────────────┬────────────┬────────────┐           │
│  │ Category   │ Value      │ Status     │           │
│  └────────────┴────────────┴────────────┘           │
│                                                      │
│  *Note: Important disclaimer text...*               │
└─────────────────────────────────────────────────────┘
```

#### Example API

```dart
class SalesReportBuilder extends PdfDocumentBuilder {
  @override
  void build() {
    addHeader(title: 'Sales Report');
    
    addHeading('Monthly Sales Overview', level: 1);
    addParagraph(
      'This is a descriptive paragraph about the content...'
    );
    
    addTable(
      headers: ['Header 1', 'Header 2', 'Header 3'],
      rows: salesData,
      style: PdfTableStyle(headerBackground: Colors.blue),
    );
    
    addHeading("Another Section's Headline", level: 1);
    addParagraph("Here's another table with different data.");
    
    addTable(
      headers: ['Category', 'Value', 'Status'],
      rows: categoryData,
    );
    
    addNote('Note: This is an important disclaimer...');
    
    addTable(
      headers: ['Item', 'Quantity', 'Unit'],
      rows: inventoryData,
    );
    
    addFooter(showPageNumber: true);
  }
}
```

---

### Additional Table Features

| Feature | Description | Priority |
|---------|-------------|----------|
| `PdfGrid` | Flexible grid layout for complex data | 🟡 Medium |
| Column Spanning | Merge cells horizontally | 🟡 Medium |
| Row Spanning | Merge cells vertically | 🟡 Medium |
| Auto-fit Columns | Automatic column width calculation | 🟢 Low |
| Bullet Lists | `addBulletList()` method | 🟢 Low |
| Numbered Lists | `addNumberedList()` method | 🟢 Low |

---

## v1.2.0 - Charts & Graphics

**Status:** 📝 Drafting  
**Target:** Q2 2025

### Features

| Feature | Description | Priority |
|---------|-------------|----------|
| Bar Chart | Vertical/horizontal bar charts | 🔴 High |
| Line Chart | Line graphs with multiple series | 🔴 High |
| Pie Chart | Pie/donut charts with labels | 🟡 Medium |
| Watermark | Text/image watermarks | 🟡 Medium |
| QR Code | QR code generation in PDF | 🟡 Medium |
| Barcode | Barcode generation (Code128, EAN, etc.) | 🟡 Medium |
| Custom Shapes | Draw custom vector shapes | 🟢 Low |

### Example API

```dart
addBarChart(
  title: 'Monthly Sales',
  data: [
    ChartData('Jan', 100),
    ChartData('Feb', 150),
    ChartData('Mar', 200),
  ],
  width: 400,
  height: 300,
);

addQrCode(
  data: 'https://example.com/invoice/123',
  size: 100,
);
```

---

## v1.3.0 - Forms & Interactive

**Status:** 💭 Ideation  
**Target:** Q3 2025

### Features

| Feature | Description | Priority |
|---------|-------------|----------|
| Text Fields | Fillable text input fields | 🔴 High |
| Checkboxes | Interactive checkboxes | 🔴 High |
| Radio Buttons | Radio button groups | 🟡 Medium |
| Dropdown | Dropdown selection fields | 🟡 Medium |
| Digital Signature | Signature field support | 🟡 Medium |
| Form Validation | Client-side validation rules | 🟢 Low |

### Example API

```dart
addTextField(
  name: 'customer_name',
  label: 'Customer Name',
  required: true,
  maxLength: 100,
);

addCheckbox(
  name: 'agree_terms',
  label: 'I agree to terms and conditions',
  checked: false,
);
```

---

## v1.4.0 - Advanced Templates

**Status:** 💭 Ideation  
**Target:** Q4 2025

### Features

| Feature | Description | Priority |
|---------|-------------|----------|
| Template System | Reusable document templates | 🔴 High |
| Multi-column Layout | Two/three column layouts | 🔴 High |
| Master Pages | Consistent page backgrounds | 🟡 Medium |
| TOC Generation | Automatic table of contents | 🟡 Medium |
| Bookmarks | PDF bookmarks/outlines | 🟡 Medium |
| Cross-references | Internal document links | 🟢 Low |

### Example API

```dart
class NewsletterTemplate extends PdfDocumentBuilder {
  @override
  void build() {
    setColumns(2, gutter: 20);
    
    addTitle('Monthly Newsletter');
    addColumnBreak();
    addSection('News 1', content);
    addSection('News 2', content);
    
    generateTableOfContents(page: 1);
  }
}
```

---

## v2.0.0 - Major Enhancements

**Status:** 🔮 Future  
**Target:** 2026

### Features

| Feature | Description | Priority |
|---------|-------------|----------|
| PDF/A Compliance | Archival format support | 🔴 High |
| Encryption | Password protection & permissions | 🔴 High |
| Digital Signatures | Sign PDFs with certificates | 🔴 High |
| Merge PDFs | Combine multiple PDFs | 🟡 Medium |
| Split PDFs | Extract pages from PDFs | 🟡 Medium |
| PDF to Image | Convert pages to images | 🟡 Medium |
| Annotations | Add comments, highlights | 🟢 Low |
| Attachments | Embed files in PDF | 🟢 Low |

---

## Backlog

Features under consideration for future releases:

### Performance
- [ ] Streaming PDF generation for large documents
- [ ] Memory optimization for image-heavy PDFs
- [ ] Lazy loading for preview widgets
- [ ] Caching for frequently used fonts

### Developer Experience
- [ ] PDF document testing utilities
- [ ] Visual PDF diff tool
- [ ] Code generation from templates
- [ ] CLI tool for PDF operations

### Integrations
- [ ] Cloud storage integration (Drive, Dropbox)
- [ ] Email sending with PDF attachment
- [ ] Print server support
- [ ] Webhook notifications on generation

### Accessibility
- [ ] PDF/UA compliance (accessibility)
- [ ] Tagged PDF support
- [ ] Screen reader optimization
- [ ] Alt text for images

### Localization
- [ ] Built-in Arabic number formatting
- [ ] Hijri calendar support
- [ ] Currency formatting by locale
- [ ] Right-to-left table support

---

## Contributing

Have a feature suggestion? Please:

1. Check if it's already in the roadmap
2. Open an issue with the `feature-request` label
3. Describe the use case and expected API

---

## Feature Request Template

```markdown
## Feature Request

**Feature Name:** 
**Category:** (Tables, Charts, Forms, Templates, Other)
**Priority:** (High, Medium, Low)

### Description
Brief description of the feature.

### Use Case
Why is this feature needed? What problem does it solve?

### Proposed API
```dart
// Example code showing how the feature would be used
```

### Alternatives Considered
Other approaches that were considered.

### Additional Context
Any other relevant information.
```

---

*Last updated: December 2024*
