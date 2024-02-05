enum Gifts {
  n1(false, 20),
  n2(true, 1, imagePath: 'assets/items/4.png'), // crystals
  n3(false, 0),
  n4(true, 1, imagePath: 'assets/items/5.png'), // bomb
  n5(false, 100),
  n6(true, 2, imagePath: 'assets/items/7.png'), // gem
  n7(false, 50),
  n8(true, 2, imagePath: 'assets/items/8.png'), // potion
  n9(false, 0),
  n10(true, 3, imagePath: 'assets/items/3.png'), // money
  n11(false, 20),
  n12(true, 3, imagePath: 'assets/items/1.png'), // coin
  n13(false, 0),
  n14(false, 10000);

  final bool isMultiplier;
  final dynamic value;
  final String? imagePath;

  const Gifts(this.isMultiplier, this.value, {this.imagePath});
}

const gameCost = -1000;
const winReward = 3000;
const dailyReward = 1500;
const initialBalance = 100000;
