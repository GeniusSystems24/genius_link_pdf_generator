
import '../compliance/compliance.dart';
import '../core/directionality.dart';
import '../template_engine_vnext/template_engine_vnext.dart';
import 'industry_pack_contract.dart';

GeniusPdfTemplateSchema _template({
  required String id,
  required String name,
  required String pack,
  required String family,
  required List<GeniusPdfTemplateElement> elements,
  Map<String, Object?> metadata = const {},
}) =>
    GeniusPdfTemplateSchema(
      templateId: id,
      templateVersion: 1,
      name: name,
      pack: pack,
      family: family,
      state: GeniusPdfTemplateState.published,
      direction: GeniusPdfDirection.auto,
      elements: elements,
      metadata: metadata,
    );

GeniusPdfTemplateElement _label(
  String id,
  String label,
  String expression, {
  GeniusPdfTemplateValueDirection valueDirection =
      GeniusPdfTemplateValueDirection.auto,
}) =>
    GeniusPdfTemplateElement.label(
      id: id,
      label: label,
      valueExpression: expression,
      valueDirection: valueDirection,
    );

/// S26-B — Retail extensions over the S16 POS pack.
class GeniusPdfRetailIndustryPack implements GeniusPdfIndustryPack {
  const GeniusPdfRetailIndustryPack();

  @override
  GeniusPdfIndustryPackManifest get manifest =>
      const GeniusPdfIndustryPackManifest(
        id: 'industry.retail',
        name: 'Retail Extensions',
        version: '1.0.0',
        description:
            'Retail labels/promotions/receipt variants over the core POS pack.',
        coreCompatibility: GeniusPdfIndustryVersionRange(
          minimumCore: '4.0.0',
          maximumCoreExclusive: '5.0.0',
        ),
        templateIds: [
          'retail.promotional-receipt',
          'retail.promotion-label',
          'retail.shelf-label',
        ],
        requiresCorePacks: ['pos'],
        capabilities: {
          'labels': true,
          'promotions': true,
          'receipts': true,
          'duplicatesCorePos': false,
        },
      );

  @override
  List<GeniusPdfTemplateSchema> templates() => [
        _template(
          id: 'retail.promotional-receipt',
          name: 'Retail Promotional Receipt',
          pack: manifest.id,
          family: 'thermalReceipt',
          metadata: const {
            'extendsCorePack': 'pos',
            'coreTemplate': 'pos.receipt',
          },
          elements: [
            GeniusPdfTemplateElement.subTemplate(
              id: 'core-pos-receipt',
              templateId: 'pos.receipt',
            ),
            GeniusPdfTemplateElement.section(
              id: 'promotion',
              visibleWhen: 'promotion.enabled == true',
              children: [
                _label(
                  'promotion-code',
                  'Promotion',
                  'promotion.code',
                  valueDirection: GeniusPdfTemplateValueDirection.ltr,
                ),
                _label(
                  'promotion-description',
                  'Offer',
                  'promotion.description',
                ),
              ],
            ),
          ],
        ),
        _template(
          id: 'retail.promotion-label',
          name: 'Retail Promotion Label',
          pack: manifest.id,
          family: 'label',
          elements: [
            _label('sku', 'SKU', 'item.sku',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            _label('name', 'Item', 'item.name'),
            _label('price', 'Price', 'item.price'),
            _label('promo', 'Promotion', 'promotion.description'),
            GeniusPdfTemplateElement.barcode(
              id: 'barcode',
              valueExpression: 'item.barcode',
            ),
          ],
        ),
        _template(
          id: 'retail.shelf-label',
          name: 'Retail Shelf Label',
          pack: manifest.id,
          family: 'label',
          elements: [
            _label('sku', 'SKU', 'item.sku',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            _label('name', 'Item', 'item.name'),
            _label('price', 'Price', 'item.price'),
          ],
        ),
      ];

  @override
  List<GeniusPdfComplianceProfile> complianceProfiles() => const [];
}

/// S26-C — Restaurant operational variants.
class GeniusPdfRestaurantIndustryPack implements GeniusPdfIndustryPack {
  const GeniusPdfRestaurantIndustryPack();

  @override
  GeniusPdfIndustryPackManifest get manifest =>
      const GeniusPdfIndustryPackManifest(
        id: 'industry.restaurant',
        name: 'Restaurant Extensions',
        version: '1.0.0',
        coreCompatibility: GeniusPdfIndustryVersionRange(
          minimumCore: '4.0.0',
          maximumCoreExclusive: '5.0.0',
        ),
        templateIds: [
          'restaurant.kot',
          'restaurant.table-ticket',
          'restaurant.kitchen-section',
          'restaurant.delivery-receipt',
        ],
        requiresCorePacks: ['pos', 'service_logistics'],
        capabilities: {
          'kot': true,
          'tableTickets': true,
          'kitchenSections': true,
          'deliveryReceipts': true,
        },
      );

  @override
  List<GeniusPdfTemplateSchema> templates() => [
        _template(
          id: 'restaurant.kot',
          name: 'Kitchen Order Ticket',
          pack: manifest.id,
          family: 'thermalReceipt',
          elements: [
            _label('order', 'Order', 'order.number',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            _label('table', 'Table', 'order.table'),
            GeniusPdfTemplateElement.section(
              id: 'items',
              repeatPath: 'order.items',
              children: [
                _label('qty', 'Qty', r'$item.quantity'),
                _label('item', 'Item', r'$item.name'),
                _label('notes', 'Notes', r'$item.notes'),
              ],
            ),
          ],
        ),
        _template(
          id: 'restaurant.table-ticket',
          name: 'Table / Order Ticket',
          pack: manifest.id,
          family: 'operationalForm',
          elements: [
            _label('order', 'Order', 'order.number',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            _label('table', 'Table', 'order.table'),
            _label('server', 'Server', 'order.server'),
          ],
        ),
        _template(
          id: 'restaurant.kitchen-section',
          name: 'Kitchen Section Ticket',
          pack: manifest.id,
          family: 'thermalReceipt',
          elements: [
            _label('section', 'Kitchen Section', 'kitchen.section'),
            GeniusPdfTemplateElement.section(
              id: 'section-items',
              repeatPath: 'kitchen.items',
              children: [
                _label('item', 'Item', r'$item.name'),
                _label('notes', 'Notes', r'$item.notes'),
              ],
            ),
          ],
        ),
        _template(
          id: 'restaurant.delivery-receipt',
          name: 'Restaurant Delivery Receipt',
          pack: manifest.id,
          family: 'transaction',
          metadata: const {
            'reuses': 'service_logistics/proof-of-delivery',
          },
          elements: [
            _label('order', 'Order', 'order.number',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            _label('customer', 'Customer', 'customer.name'),
            _label('address', 'Delivery Address', 'delivery.address'),
            _label('driver', 'Driver', 'delivery.driver'),
          ],
        ),
      ];

  @override
  List<GeniusPdfComplianceProfile> complianceProfiles() => const [];
}

/// S26-D — Construction / Real Estate variants over projects/transactions.
class GeniusPdfConstructionRealEstateIndustryPack
    implements GeniusPdfIndustryPack {
  const GeniusPdfConstructionRealEstateIndustryPack();

  @override
  GeniusPdfIndustryPackManifest get manifest =>
      const GeniusPdfIndustryPackManifest(
        id: 'industry.construction_real_estate',
        name: 'Construction & Real Estate Extensions',
        version: '1.0.0',
        coreCompatibility: GeniusPdfIndustryVersionRange(
          minimumCore: '4.0.0',
          maximumCoreExclusive: '5.0.0',
        ),
        templateIds: [
          'construction.progress-certificate',
          'construction.boq-report',
          'real-estate.property-unit-document',
          'construction.project-billing-extension',
        ],
        requiresCorePacks: ['assets_projects', 'sales'],
        capabilities: {
          'progressCertificates': true,
          'boq': true,
          'propertyUnits': true,
          'projectBilling': true,
        },
      );

  @override
  List<GeniusPdfTemplateSchema> templates() => [
        _template(
          id: 'construction.progress-certificate',
          name: 'Progress Certificate',
          pack: manifest.id,
          family: 'certificate',
          elements: [
            _label('project', 'Project', 'project.name'),
            _label('certificate', 'Certificate No.', 'certificate.number',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            _label('period', 'Period', 'certificate.period'),
            GeniusPdfTemplateElement.summary(
              id: 'progress-summary',
              items: const [
                {
                  'label': 'Previous',
                  'valueExpression': 'progress.previous',
                },
                {
                  'label': 'Current',
                  'valueExpression': 'progress.current',
                },
                {
                  'label': 'Cumulative',
                  'valueExpression': 'progress.cumulative',
                },
              ],
            ),
          ],
        ),
        _template(
          id: 'construction.boq-report',
          name: 'Measurement / BOQ Report',
          pack: manifest.id,
          family: 'analyticalReport',
          elements: [
            _label('project', 'Project', 'project.name'),
            GeniusPdfTemplateElement.section(
              id: 'boq-lines',
              repeatPath: 'boq.lines',
              children: [
                _label('code', 'Code', r'$item.code',
                    valueDirection: GeniusPdfTemplateValueDirection.ltr),
                _label('description', 'Description', r'$item.description'),
                _label('quantity', 'Quantity', r'$item.quantity'),
                _label('rate', 'Rate', r'$item.rate'),
                _label('amount', 'Amount', r'$item.amount'),
              ],
            ),
          ],
        ),
        _template(
          id: 'real-estate.property-unit-document',
          name: 'Property / Unit / Customer Document',
          pack: manifest.id,
          family: 'operationalForm',
          elements: [
            _label('property', 'Property', 'property.name'),
            _label('unit', 'Unit', 'unit.code',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            _label('customer', 'Customer', 'customer.name'),
            _label('status', 'Status', 'unit.status'),
          ],
        ),
        _template(
          id: 'construction.project-billing-extension',
          name: 'Project Billing Extension',
          pack: manifest.id,
          family: 'transaction',
          metadata: const {'reuses': 'assets_projects/project-billing'},
          elements: [
            _label('project', 'Project', 'project.name'),
            _label('billing', 'Billing Ref.', 'billing.reference',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            _label('certified', 'Certified Amount', 'billing.certifiedAmount'),
            _label('retention', 'Retention', 'billing.retention'),
          ],
        ),
      ];

  @override
  List<GeniusPdfComplianceProfile> complianceProfiles() => const [];
}

/// S26-E — intentionally only unregulated report shells.
///
/// Regulated healthcare/education domain entities stay in external plugins.
class GeniusPdfHealthcareEducationShellPack
    implements GeniusPdfIndustryPack {
  const GeniusPdfHealthcareEducationShellPack();

  @override
  GeniusPdfIndustryPackManifest get manifest =>
      const GeniusPdfIndustryPackManifest(
        id: 'industry.healthcare_education_shells',
        name: 'Healthcare & Education Report Shells',
        version: '1.0.0',
        description:
            'Generic report shells; regulated domain models are external.',
        coreCompatibility: GeniusPdfIndustryVersionRange(
          minimumCore: '4.0.0',
          maximumCoreExclusive: '5.0.0',
        ),
        templateIds: [
          'healthcare.generic-report-shell',
          'education.generic-report-shell',
        ],
        domainExtensions: [
          GeniusPdfIndustryDomainExtension(
            namespace: 'plugin.healthcare',
            modelKeys: ['reportHeader', 'reportRows', 'reportFooter'],
            description:
                'Plugin-specific regulated healthcare models are required.',
          ),
          GeniusPdfIndustryDomainExtension(
            namespace: 'plugin.education',
            modelKeys: ['reportHeader', 'reportRows', 'reportFooter'],
            description:
                'Plugin-specific education models remain outside core.',
          ),
        ],
        capabilities: {
          'genericReportShellsOnly': true,
          'regulatedDomainModelsInCore': false,
        },
      );

  @override
  List<GeniusPdfTemplateSchema> templates() => [
        for (final industry in ['healthcare', 'education'])
          _template(
            id: '$industry.generic-report-shell',
            name: '${industry[0].toUpperCase()}${industry.substring(1)} '
                'Generic Report Shell',
            pack: manifest.id,
            family: 'analyticalReport',
            metadata: {
              'domainNamespace': 'plugin.$industry',
              'regulatedModelOwnership': 'external-plugin',
            },
            elements: [
              _label('title', 'Report', 'reportHeader.title'),
              GeniusPdfTemplateElement.section(
                id: 'rows',
                repeatPath: 'reportRows',
                children: [
                  _label('label', 'Label', r'$item.label'),
                  _label('value', 'Value', r'$item.value'),
                ],
              ),
              _label('footer', 'Footer', 'reportFooter.text'),
            ],
          ),
      ];

  @override
  List<GeniusPdfComplianceProfile> complianceProfiles() => const [];
}

/// S26-F — variants that explicitly reuse service/logistics/transaction
/// families rather than duplicating them.
class GeniusPdfMobilityDistributionHospitalityPack
    implements GeniusPdfIndustryPack {
  const GeniusPdfMobilityDistributionHospitalityPack();

  @override
  GeniusPdfIndustryPackManifest get manifest =>
      const GeniusPdfIndustryPackManifest(
        id: 'industry.mobility_distribution_hospitality',
        name: 'Automotive, Distribution & Hospitality Extensions',
        version: '1.0.0',
        coreCompatibility: GeniusPdfIndustryVersionRange(
          minimumCore: '4.0.0',
          maximumCoreExclusive: '5.0.0',
        ),
        templateIds: [
          'automotive.vehicle-service-variant',
          'distribution.route-variant',
          'hospitality.guest-folio-variant',
        ],
        requiresCorePacks: [
          'service_logistics',
          'sales',
        ],
        capabilities: {
          'vehicleService': true,
          'routeDistribution': true,
          'guestFolio': true,
          'reusesCoreFamilies': true,
        },
      );

  @override
  List<GeniusPdfTemplateSchema> templates() => [
        _template(
          id: 'automotive.vehicle-service-variant',
          name: 'Vehicle Service Variant',
          pack: manifest.id,
          family: 'operationalForm',
          metadata: const {'reuses': 'service_logistics/service-order'},
          elements: [
            _label('vehicle', 'Vehicle', 'vehicle.registration',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            _label('vin', 'VIN', 'vehicle.vin',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            _label('service', 'Service Order', 'service.number',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            _label('odometer', 'Odometer', 'vehicle.odometer'),
          ],
        ),
        _template(
          id: 'distribution.route-variant',
          name: 'Distribution Route Variant',
          pack: manifest.id,
          family: 'operationalForm',
          metadata: const {'reuses': 'service_logistics/manifest'},
          elements: [
            _label('route', 'Route', 'route.code',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            _label('vehicle', 'Vehicle', 'vehicle.registration',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            GeniusPdfTemplateElement.section(
              id: 'stops',
              repeatPath: 'route.stops',
              children: [
                _label('stop', 'Stop', r'$item.sequence'),
                _label('customer', 'Customer', r'$item.customer'),
                _label('address', 'Address', r'$item.address'),
              ],
            ),
          ],
        ),
        _template(
          id: 'hospitality.guest-folio-variant',
          name: 'Guest / Folio Operational Variant',
          pack: manifest.id,
          family: 'transaction',
          metadata: const {'reuses': 'transaction-family'},
          elements: [
            _label('folio', 'Folio', 'folio.number',
                valueDirection: GeniusPdfTemplateValueDirection.ltr),
            _label('guest', 'Guest', 'guest.name'),
            _label('room', 'Room', 'stay.room'),
            GeniusPdfTemplateElement.section(
              id: 'charges',
              repeatPath: 'folio.charges',
              children: [
                _label('date', 'Date', r'$item.date',
                    valueDirection: GeniusPdfTemplateValueDirection.ltr),
                _label('description', 'Description', r'$item.description'),
                _label('amount', 'Amount', r'$item.amount'),
              ],
            ),
          ],
        ),
      ];

  @override
  List<GeniusPdfComplianceProfile> complianceProfiles() => const [];
}

class GeniusPdfBuiltInIndustryPacks {
  const GeniusPdfBuiltInIndustryPacks._();

  static const all = <GeniusPdfIndustryPack>[
    GeniusPdfRetailIndustryPack(),
    GeniusPdfRestaurantIndustryPack(),
    GeniusPdfConstructionRealEstateIndustryPack(),
    GeniusPdfHealthcareEducationShellPack(),
    GeniusPdfMobilityDistributionHospitalityPack(),
  ];

  static GeniusPdfIndustryPackRegistry registry({
    String coreVersion = '4.0.0',
  }) {
    final value =
        GeniusPdfIndustryPackRegistry(coreVersion: coreVersion);
    for (final pack in all) {
      value.register(pack);
    }
    return value;
  }
}
