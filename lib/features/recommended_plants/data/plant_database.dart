import '../models/recommended_plant.dart';

final List<RecommendedPlant> allPlants = [
  // Москва и ЦФО
  RecommendedPlant(
    name: 'Липа',
    type: 'дерево',
    description: 'Теневыносливое дерево, отлично подходит для городских условий.',
    region: 'Москва',
  ),
  RecommendedPlant(
    name: 'Сирень',
    type: 'кустарник',
    description: 'Ароматный, неприхотливый кустарник для сада.',
    region: 'Москва',
  ),
  RecommendedPlant(
    name: 'Хоста',
    type: 'растение',
    description: 'Идеальна для тенистых участков.',
    region: 'Москва',
  ),
  RecommendedPlant(
    name: 'Боярышник',
    type: 'кустарник',
    description: 'Морозостойкий, декоративный, плоды полезны.',
    region: 'Москва',
  ),
  RecommendedPlant(
    name: 'Астильба',
    type: 'растение',
    description: 'Цветёт в тени, устойчива к влажности.',
    region: 'Москва',
  ),

  // Санкт-Петербург
  RecommendedPlant(
    name: 'Ель',
    type: 'дерево',
    description: 'Морозостойкое хвойное дерево.',
    region: 'Санкт-Петербург',
  ),
  RecommendedPlant(
    name: 'Флокс',
    type: 'растение',
    description: 'Цветёт всё лето, любит влажную почву.',
    region: 'Санкт-Петербург',
  ),
  RecommendedPlant(
    name: 'Калина',
    type: 'кустарник',
    description: 'Декоративна осенью, плоды съедобны.',
    region: 'Санкт-Петербург',
  ),
  RecommendedPlant(
    name: 'Папоротник мужской',
    type: 'растение',
    description: 'Отлично растёт в тени и при высокой влажности.',
    region: 'Санкт-Петербург',
  ),
  RecommendedPlant(
    name: 'Ива белая',
    type: 'дерево',
    description: 'Любит влажные почвы, быстро растёт.',
    region: 'Санкт-Петербург',
  ),

  // Новосибирск
  RecommendedPlant(
    name: 'Берёза',
    type: 'дерево',
    description: 'Символ России, отлично растёт в Сибири.',
    region: 'Новосибирск',
  ),
  RecommendedPlant(
    name: 'Ирис сибирский',
    type: 'растение',
    description: 'Морозостойкий, любит влажные почвы.',
    region: 'Новосибирск',
  ),
  RecommendedPlant(
    name: 'Смородина золотистая',
    type: 'кустарник',
    description: 'Устойчива к морозам, декоративна весной.',
    region: 'Новосибирск',
  ),
  RecommendedPlant(
    name: 'Черёмуха',
    type: 'дерево',
    description: 'Морозостойка, цветёт пышно, плоды съедобны.',
    region: 'Новосибирск',
  ),
  RecommendedPlant(
    name: 'Флокс метельчатый',
    type: 'растение',
    description: 'Цветёт поздним летом, зимует без укрытия.',
    region: 'Новосибирск',
  ),

  // Екатеринбург
  RecommendedPlant(
    name: 'Пион',
    type: 'кустарник',
    description: 'Крупные цветы, долгожитель сада.',
    region: 'Екатеринбург',
  ),
  RecommendedPlant(
    name: 'Лиственница',
    type: 'дерево',
    description: 'Хвойное, но сбрасывает иголки зимой, морозостойка.',
    region: 'Екатеринбург',
  ),
  RecommendedPlant(
    name: 'Адонис весенний',
    type: 'растение',
    description: 'Первым зацветает весной, устойчив к заморозкам.',
    region: 'Екатеринбург',
  ),
  RecommendedPlant(
    name: 'Калина гордовина',
    type: 'кустарник',
    description: 'Растёт на любых почвах, морозостойка.',
    region: 'Екатеринбург',
  ),
  RecommendedPlant(
    name: 'Купена',
    type: 'растение',
    description: 'Теневынослива, цветёт в начале лета.',
    region: 'Екатеринбург',
  ),

  // Казань
  RecommendedPlant(
    name: 'Клен',
    type: 'дерево',
    description: 'Устойчив к загрязнению воздуха.',
    region: 'Казань',
  ),
  RecommendedPlant(
    name: 'Жасмин',
    type: 'кустарник',
    description: 'Ароматные белые цветы в начале лета.',
    region: 'Казань',
  ),
  RecommendedPlant(
    name: 'Люпин',
    type: 'растение',
    description: 'Высокий, яркий, любит солнце и дренированную почву.',
    region: 'Казань',
  ),
  RecommendedPlant(
    name: 'Дуб черешчатый',
    type: 'дерево',
    description: 'Долгожитель, устойчив к засухе и морозам.',
    region: 'Казань',
  ),
  RecommendedPlant(
    name: 'Бузина',
    type: 'кустарник',
    description: 'Быстрорастущая, плоды полезны.',
    region: 'Казань',
  ),

  // Нижний Новгород
  RecommendedPlant(
    name: 'Рябина обыкновенная',
    type: 'дерево',
    description: 'Декоративна осенью, ягоды полезны.',
    region: 'Нижний Новгород',
  ),
  RecommendedPlant(
    name: 'Сирень венгерская',
    type: 'кустарник',
    description: 'Пышное цветение, морозостойка.',
    region: 'Нижний Новгород',
  ),
  RecommendedPlant(
    name: 'Волжанка',
    type: 'растение',
    description: 'Любит влажные почвы, цветёт в июне.',
    region: 'Нижний Новгород',
  ),
  RecommendedPlant(
    name: 'Ясень',
    type: 'дерево',
    description: 'Стройное дерево, хорошо растёт на Волге.',
    region: 'Нижний Новгород',
  ),
  RecommendedPlant(
    name: 'Медуница',
    type: 'растение',
    description: 'Цветёт рано весной, теневынослива.',
    region: 'Нижний Новгород',
  ),

  // Челябинск
  RecommendedPlant(
    name: 'Тополь пирамидальный',
    type: 'дерево',
    description: 'Быстрорастущий, устойчив к городским условиям.',
    region: 'Челябинск',
  ),
  RecommendedPlant(
    name: 'Шиповник',
    type: 'кустарник',
    description: 'Морозостоек, плоды богаты витамином C.',
    region: 'Челябинск',
  ),
  RecommendedPlant(
    name: 'Астра альпийская',
    type: 'растение',
    description: 'Цветёт весной, морозостойка.',
    region: 'Челябинск',
  ),
  RecommendedPlant(
    name: 'Можжевельник',
    type: 'кустарник',
    description: 'Хвойный, очищает воздух, зимует без укрытия.',
    region: 'Челябинск',
  ),
  RecommendedPlant(
    name: 'Колокольчик персиколистный',
    type: 'растение',
    description: 'Любит солнце, цветёт всё лето.',
    region: 'Челябинск',
  ),

  // Самара
  RecommendedPlant(
    name: 'Акация белая',
    type: 'дерево',
    description: 'Цветёт в июне, засухоустойчива.',
    region: 'Самара',
  ),
  RecommendedPlant(
    name: 'Лаванда узколистная',
    type: 'растение',
    description: 'Любит солнце и сухую почву, ароматна.',
    region: 'Самара',
  ),
  RecommendedPlant(
    name: 'Гледичия',
    type: 'дерево',
    description: 'Теневынослива, устойчива к засухе.',
    region: 'Самара',
  ),
  RecommendedPlant(
    name: 'Эспарцет',
    type: 'растение',
    description: 'Медонос, цветёт в жару, укрепляет почву.',
    region: 'Самара',
  ),
  RecommendedPlant(
    name: 'Жимолость каприфоль',
    type: 'кустарник',
    description: 'Декоративна, цветёт долго, любит солнце.',
    region: 'Самара',
  ),

  // Омск
  RecommendedPlant(
    name: 'Ива козья',
    type: 'кустарник',
    description: 'Растёт даже на заболоченных почвах, морозостойка.',
    region: 'Омск',
  ),
  RecommendedPlant(
    name: 'Вербейник монетчатый',
    type: 'растение',
    description: 'Почвопокровное, любит влагу и тень.',
    region: 'Омск',
  ),
  RecommendedPlant(
    name: 'Сосна обыкновенная',
    type: 'дерево',
    description: 'Морозо- и засухоустойчива, растёт в лесостепи.',
    region: 'Омск',
  ),
  RecommendedPlant(
    name: 'Манжетка',
    type: 'растение',
    description: 'Цветёт всё лето, нетребовательна к уходу.',
    region: 'Омск',
  ),
  RecommendedPlant(
    name: 'Рябина сибирская',
    type: 'дерево',
    description: 'Плоды крупнее обычной, морозостойка.',
    region: 'Омск',
  ),
];