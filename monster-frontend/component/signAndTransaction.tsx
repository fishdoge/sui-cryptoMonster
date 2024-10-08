"use client"
import { ConnectButton, useCurrentAccount, useSignAndExecuteTransaction,useSuiClient,useSignTransaction } from '@mysten/dapp-kit';
import { useState } from 'react';
import { Transaction } from '@mysten/sui/transactions';
// import { SuiClient, getFullnodeUrl  } from '@mysten/sui/client';


export function SignAndSend() {
	const { mutate: signAndExecuteTransaction } = useSignAndExecuteTransaction();
	const { mutateAsync: signTransaction } = useSignTransaction();
	const [digest, setDigest] = useState('');
	const currentAccount = useCurrentAccount();
	const client = useSuiClient();



	const tx = new Transaction();

	const [coin] = tx.splitCoins(tx.gas, [100000]);
	tx.transferObjects([coin], '0x526b031f8607fa3b751d9004992df2cb3e850899f294ea039fbc93e843e75a16')



	const testTransferSui = async() =>{

			const { bytes, signature, reportTransactionEffects } = await signTransaction({
				transaction: new Transaction(),
				chain: 'sui:devnet',
			});

			const executeResult = await client.executeTransactionBlock({
				transactionBlock: bytes,
				signature,
				options: {
					showRawEffects: true,
				},
			});

			// Always report transaction effects to the wallet after execution
			reportTransactionEffects(executeResult.rawEffects!);

			console.log(executeResult);

	}

	const transferSui = ()=>{
		signAndExecuteTransaction(
			{
				transaction: tx,
				chain: 'sui:devnet',
			},
			{
				onSuccess: (result) => {
					console.log('executed transaction', result);
					setDigest(result.digest);
				},
			},
		);
	}

    // transfer the split coin to a specific address



	return (
		<div style={{ padding: 20 }}>
			<ConnectButton />
			{currentAccount && (
				<>
					<div className='mt-2 rounded-full py-2 px-4'>
						<button	onClick={() => testTransferSui()}>
							Sign and execute transaction
						</button>

					</div>
					<div>Digest: {digest}</div>
					<div className='mt-2 w-[100px] bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full'>
						<button onClick={()=>transferSui()}>transfer</button>
					</div>
					<div className='mt-2 w-[100px] bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full'>
						<button onClick={()=>{console.log('Sui Client URL:', client);}}>test</button>
					</div>

				</>
			)}
		</div>
	);
}