enum WheelGift {
  n1(Gift.coin),
  n2(Gift.coins),
  n3(Gift.chest),
  n4(Gift.coin),
  n5(Gift.chest),
  n6(Gift.coins),
  n7(Gift.crown),
  n8(Gift.coin),
  n9(Gift.crown),
  n10(Gift.coins),
  n11(Gift.coin),
  n12(Gift.chest),
  n13(Gift.crown),
  n14(Gift.coins);

  final Gift gift;

  const WheelGift(this.gift);
}

enum Gift {
  coin(10, imagePath: 'assets/items/3.png'),
  coins(20, imagePath: 'assets/items/2.png'),
  chest(15, imagePath: 'assets/items/0.png'),
  crown(5, imagePath: 'assets/items/1.png');

  final int value;
  final String imagePath;

  const Gift(this.value, {required this.imagePath});
}

const gameCost = -1000;
const slotPokiesWinReward = 1000;
const dailyReward = 1500;
const initialBalance = 100000;
