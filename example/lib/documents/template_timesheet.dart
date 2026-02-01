import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'template_build_result.dart';

Future<TemplateBuildResult> buildTemplateTimesheetBytes(
  GeniusPdfConfig config,
) async {
  final templateBuilder = TemplateBuilder(
    id: 'demo-timesheet',
    name: 'Timesheet',
    nameAr: 'سجل دوام',
  )
      .addVariable(TemplateVariable.string('employee', required: true))
      .addVariable(TemplateVariable.string('period', required: true))
      .addVariable(TemplateVariable.list('entries', required: true))
      .addVariable(TemplateVariable.currency('totalHours'))
      .addText('TIMESHEET', textAr: 'سجل دوام', fontSize: 22)
      .addSpacer(10)
      .addVariableElement('employee', prefix: 'Employee: ')
      .addVariableElement('period', prefix: 'Period: ')
      .addSpacer(10)
      .addDivider()
      .addSpacer(8)
      .addTable(
        columns: [
          const TableColumn(field: 'date', title: 'Date', flex: 1),
          const TableColumn(field: 'task', title: 'Task', flex: 2),
          const TableColumn(field: 'hours', title: 'Hours', flex: 1),
        ],
        dataVariable: 'entries',
      )
      .addSpacer(8)
      .addDivider()
      .addSpacer(6)
      .addVariableElement('totalHours', prefix: 'Total Hours: ')
      .addSpacer(6)
      .addText('Manager approval: ____________________', fontSize: 11);

  templateBuilder.description = 'Timesheet with daily tasks and hours';
  final template = templateBuilder.build();

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'employee': 'Huda Al-Qahtani',
      'period': '2026-01-01 to 2026-01-15',
      'entries': [
        {'date': '2026-01-01', 'task': 'Client onboarding', 'hours': 6},
        {'date': '2026-01-02', 'task': 'Report preparation', 'hours': 7},
        {'date': '2026-01-03', 'task': 'System testing', 'hours': 5},
      ],
      'totalHours': 18,
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}
