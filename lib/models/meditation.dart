class Meditation {
  final String title;
  final List<Section> sections;

  Meditation(this.title, this.sections);
}

class Section {
  final String name;
  final String assetUrl;
  Duration duration;

  Section(this.name, this.assetUrl, this.duration);
}