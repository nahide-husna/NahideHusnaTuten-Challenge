import { Transaction } from "@mysten/sui/transactions";

export const buyHero = (packageId: string, listHeroId: string, priceInSui: string) => {
  const tx = new Transaction();
  
  // TODO: Convert SUI to MIST (1 SUI = 1,000,000,000 MIST)
    // Hints:
    // const priceInMist = ?
  
  // Çözüm:
  const priceInMist = BigInt(parseFloat(priceInSui) * 1_000_000_000);

  // TODO: Split coin for exact payment
    // Hints  
    // Use tx.splitCoins(tx.gas, [priceInMist]) to create a payment coin
    // const [paymentCoin] = ?
  
  // Çözüm:
  // tx.gas, cüzdandaki SUI coinlerini temsil eder.
  // Bu coinlerden tam olarak priceInMist miktarı kadar yeni bir coin ayırıyoruz.
  const [paymentCoin] = tx.splitCoins(tx.gas, [priceInMist]);

  // TODO: Add moveCall to buy a hero
  // Function: `${packageId}::marketplace::buy_hero`
  // Arguments: listHeroId (object), paymentCoin (coin)
    // Hints:
    // Use tx.object() for the ListHero object
    // Use the paymentCoin from splitCoins for payment
    
  // Çözüm:
  tx.moveCall({
    target: `${packageId}::marketplace::buy_hero`,
    arguments: [
      tx.object(listHeroId), // Satın alınacak listeleme nesnesi
      paymentCoin,           // Ayırdığımız ödeme coini
    ],
  });

  return tx;
};