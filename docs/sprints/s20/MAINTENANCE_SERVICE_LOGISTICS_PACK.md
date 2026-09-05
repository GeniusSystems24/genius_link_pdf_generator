
# S20 — Maintenance, Service & Logistics Pack

Version: **4.0.0**

S20 depends on S19 and completes Maintenance, Service and Logistics coverage
without introducing new table, checklist, label or profile engines.

## Maintenance and service

Public outputs:

- Service Order
- Maintenance Work Order
- Preventive Maintenance Schedule
- Maintenance Checklist
- Technician Report
- Service Completion Report
- Spare Parts Usage
- Warranty Report
- Inspection Report
- Calibration / Service History

S20 deliberately reuses S18 quality checklist and measurement semantics through
`GeniusServiceChecklistItem` and `GeniusServiceChecklistStatus` typedefs.

## Logistics

Public outputs:

- Shipment Document
- Packing List
- Dispatch Note
- Waybill
- Manifest
- Trip Sheet
- Trip Report
- Shipping Label
- Pallet Label
- Container List
- Freight Summary
- Proof of Delivery

Tracking numbers, shipment numbers, route codes, vehicle IDs, plate numbers,
container numbers and signature references remain structured values beside
localized Arabic addresses/descriptions.

## Shared mechanics

Typed public primitives cover:

- `GeniusLogisticsRouteReference`
- `GeniusLogisticsRouteStop`
- `GeniusServicePersonIdentity`
- `GeniusLogisticsVehicleIdentity`
- `GeniusServiceChecklistItem`
- `GeniusDeliveryProofSignature`
- `GeniusGeoTimeMetadata`
- `GeniusServiceAttachmentReference`

Proof-of-delivery reports carry signature references, signer identity, capture
time, optional geo coordinates and attachment/photo references.

## Label and thermal profiles

`GeniusServiceLogisticsPrintProfiles` returns S11 public profiles:

- Shipping Label
- Pallet Label
- Shipping Label Sheet
- 58mm thermal
- 80mm thermal

Shipping and Pallet label documents extend the existing
`GeniusPdfLabelPrintDocument`; there is no second label renderer.

## QA

Automated tests and the semantic QA matrix cover:

- multi-stop manifests;
- long shipment items;
- Arabic addresses + Latin tracking numbers;
- label and thermal profile selection;
- proof-of-delivery signatures;
- route/vehicle/driver/technician blocks;
- geo/time metadata;
- attachment/photo references;
- LTR/RTL and multi-page scenarios.

The S20 Dashboard verification screen uses the real public API and exposes
Maintenance, Service and Logistics scenarios including labels and POD.
