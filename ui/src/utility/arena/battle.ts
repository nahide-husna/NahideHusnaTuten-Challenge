import { Transaction } from "@mysten/sui/transactions";

export const battle = (packageId: string, heroId: string, arenaId: string) => {
  const tx = new Transaction();
  
  // TODO: Add moveCall to start a battle
  // Function: `${packageId}::arena::battle`
  // Arguments: heroId (object), arenaId (object)
    // Hints:
    // Use tx.object() for both hero and battle place objects
    // The battle winner is determined by hero power comparison
    // Winner takes both heroes
  
  // Çözüm:
  tx.moveCall({
    target: `${packageId}::arena::battle`,
    arguments: [
      tx.object(heroId), // Meydan okuyan (saldıran) hero'nun nesnesi
      tx.object(arenaId), // Savaşın gerçekleşeceği arena nesnesi
    ],
  });

  return tx;
};