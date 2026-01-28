# Charts & Graphics Feature

**Version:** 1.2.0  
**Status:** 📝 Drafting  
**Priority:** High

---

## Overview

Add chart and graphics support for data visualization in PDF documents.

---

## Requirements

### Chart Types

1. **Bar Chart**
   - Vertical bars
   - Horizontal bars
   - Grouped bars
   - Stacked bars

2. **Line Chart**
   - Single series
   - Multiple series
   - Area chart (filled)
   - Smooth/curved lines

3. **Pie Chart**
   - Basic pie
   - Donut chart
   - Exploded segments
   - Labels and percentages

### Graphics

1. **QR Code**
   - Generate QR from text/URL
   - Customizable size
   - Error correction levels

2. **Barcode**
   - Code 128
   - EAN-13
   - UPC-A
   - QR Code

3. **Watermark**
   - Text watermark
   - Image watermark
   - Diagonal/horizontal
   - Opacity control

---

## API Design

### Bar Chart

```dart
addBarChart(
  title: 'Monthly Sales',
  data: [
    BarData('Jan', 100, color: Colors.blue),
    BarData('Feb', 150, color: Colors.green),
    BarData('Mar', 200, color: Colors.orange),
  ],
  width: 400,
  height: 300,
  showValues: true,
  showLegend: true,
);
```

### Line Chart

```dart
addLineChart(
  title: 'Revenue Trend',
  series: [
    LineSeries(
      name: '2023',
      data: [100, 120, 140, 180, 200],
      color: Colors.blue,
    ),
    LineSeries(
      name: '2024',
      data: [150, 170, 190, 220, 250],
      color: Colors.green,
    ),
  ],
  xLabels: ['Q1', 'Q2', 'Q3', 'Q4'],
  width: 500,
  height: 300,
);
```

### Pie Chart

```dart
addPieChart(
  title: 'Market Share',
  data: [
    PieData('Product A', 40, color: Colors.blue),
    PieData('Product B', 30, color: Colors.green),
    PieData('Others', 30, color: Colors.grey),
  ],
  size: 250,
  showPercentages: true,
  donut: true,
  donutRadius: 0.5,
);
```

### QR Code

```dart
addQrCode(
  data: 'https://example.com/invoice/123',
  x: 400,
  y: 100,
  size: 100,
  errorCorrectionLevel: QrErrorCorrection.high,
);
```

### Barcode

```dart
addBarcode(
  data: '1234567890123',
  type: BarcodeType.ean13,
  x: 50,
  y: 700,
  width: 200,
  height: 50,
  showText: true,
);
```

### Watermark

```dart
addTextWatermark(
  text: 'CONFIDENTIAL',
  fontSize: 72,
  color: Colors.grey.withValues(alpha:0.3),
  rotation: -45,
);

addImageWatermark(
  image: logoBytes,
  opacity: 0.1,
  position: WatermarkPosition.center,
);
```

---

## Implementation Notes

1. Charts may require a third-party library or custom drawing
2. QR/Barcode can use existing Flutter packages
3. Watermarks should be added to page template

---

## Dependencies

Potential dependencies:

- `qr_flutter` or `barcode` for QR/barcode generation
- Custom drawing for charts using Syncfusion graphics

---

*Created: December 2025*.
