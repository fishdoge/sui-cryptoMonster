import { ConnectButton, useCurrentAccount, useSignAndExecuteTransaction } from '@mysten/dapp-kit';
import { useState } from 'react';
import { Transaction } from '@mysten/sui/transactions';
 

export function SignAndSend() {
	const { mutate: signAndExecuteTransaction } = useSignAndExecuteTransaction();
	const [digest, setDigest] = useState('');
	const currentAccount = useCurrentAccount();


    const tx = new Transaction();
    const [coin] = tx.splitCoins(tx.gas, [100]);
 
    // transfer the split coin to a specific address
    tx.transferObjects([coin], '0xSomeSuiAddress');

 
	return (
		<div style={{ padding: 20 }}>
			<ConnectButton />
			{currentAccount && (
				<>
					<div>
						<button
							onClick={() => {
								signAndExecuteTransaction(
									{
										transaction: new Transaction(),
										chain: 'sui:devnet',
									},
									{
										onSuccess: (result) => {
											console.log('executed transaction', result);
											setDigest(result.digest);
										},
									},
								);
							}}
						>
							Sign and execute transaction
						</button>
					</div>
					<div>Digest: {digest}</div>
				</>
			)}
		</div>
	);
}