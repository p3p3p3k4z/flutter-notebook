class Pokemon {
  final String name;
  final List<String> abilities;
  final String imageURL;
  final List<String> galleryImages;

  Pokemon({
    required this.name,
    required this.abilities,
    required this.imageURL,
    required this.galleryImages,
  });

  factory Pokemon.fromJSON(Map<String, dynamic> json) {
    final abilitiesList = (json['abilities'] as List)
        .map((item) => item['ability']['name'] as String)
        .toList();

    final image = json['sprites']['other']['dream_world']['front_default'];

    final spritesJson = json['sprites'];
    final List<String> images = [];

    if (spritesJson['front_default'] != null) {
      images.add(spritesJson['front_default']);
    }
    if (spritesJson['back_default'] != null) {
      images.add(spritesJson['back_default']);
    }
    if (spritesJson['front_shiny'] != null) {
      images.add(spritesJson['front_shiny']);
    }
    if (spritesJson['back_shiny'] != null) {
      images.add(spritesJson['back_shiny']);
    }

    return Pokemon(
      name: json['name'],
      abilities: abilitiesList,
      imageURL: image,
      galleryImages: images,
    );
  }
}


/*
{
  'name': "pikachu"
  'abilities': [
    {
      'ability' : {
          'name': 'fire'
        }
    }

  ],

  'sprites': {
    'other': 
      'dreamWorld': {'front_default': url}

  }

}

* */