class Meditation {
  final String title;
  final List<Section> sections;
  final String duration;

  Meditation(this.title, this.sections, this.duration);
}

class Section {
  final String name;
  final String assetUrl;
  Duration duration;

  Section(this.name, this.assetUrl, this.duration);
}