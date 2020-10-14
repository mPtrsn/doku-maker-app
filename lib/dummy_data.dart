import 'package:doku_maker/models/project_tag.dart';

import 'models/entries/project_link_entry.dart';
import 'models/project.dart';
import 'models/entries/project_text_entry.dart';

const List<Project> DUMMY_DATA = [
  const Project(
    1,
    'first',
    'peter',
    [
      'klaus',
      'hans',
    ],
    [
      const ProjectLinkEntry(
        id: 1,
        title: 'Setup',
        tags: [
          const ProjectTag('Coding'),
          const ProjectTag('Planning'),
        ],
        link: 'ein link',
      ),
    ],
  ),
  const Project(
    2,
    'second',
    'peter',
    [],
    [
      const ProjectTextEntry(
        id: 1,
        title: 'Setup',
        tags: [
          const ProjectTag('Planning'),
        ],
        text: 'Das ist ein Entry Text',
      ),
      const ProjectTextEntry(
        id: 2,
        title: 'Arduino Code',
        tags: [
          const ProjectTag('Coding'),
          const ProjectTag('Arduino'),
        ],
        text: 'Ein weiterer Entry Text',
      ),
      const ProjectTextEntry(
        id: 3,
        title: '3D-Print',
        tags: [
          const ProjectTag('3D-Print'),
          const ProjectTag('Drawing'),
        ],
        text: 'Ein weiterer Entry Text',
      ),
      const ProjectTextEntry(
        id: 4,
        title: 'Assembly',
        tags: [
          const ProjectTag('Coding'),
          const ProjectTag('Planning'),
        ],
        text: 'Ein weiterer Entry Text',
      ),
    ],
  ),
];
