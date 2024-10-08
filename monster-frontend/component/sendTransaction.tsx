import { Transaction } from '@mysten/sui/transactions';
import {
	ConnectButton,
	useCurrentAccount,
	useSignTransaction,
	useSuiClient,
} from '@mysten/dapp-kit';
import { toBase64 } from '@mysten/sui/utils';
import { SetStateAction, useState } from 'react';


export function SendTransaction() {
	const { mutateAsync: signTransaction } = useSignTransaction();
	const [signatureText, setSignature] = useState('');
	const client = useSuiClient();
	const currentAccount = useCurrentAccount();

	return (
		<div style={{ padding: 20 }}>
			<ConnectButton />
			{currentAccount && (
				<>
					<div className='mt-2'>
						<button className='mt-2 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded'
							onClick={async () => {

								const { bytes, signature, reportTransactionEffects } = await signTransaction({
									transaction: new Transaction(),
									chain: 'sui:devnet',
								});

								setSignature(signature)

								const executeResult = await client.executeTransactionBlock({
									transactionBlock: bytes,
									signature,
									options: {
										showRawEffects: true,
									},
								});

								// Always report transaction effects to the wallet after execution
								if (executeResult.rawEffects) {
									reportTransactionEffects(JSON.stringify(executeResult.rawEffects!));
								}

								console.log(executeResult);
							}}
						>
							Sign empty transaction
						</button>
					</div>
					<div>Signature: {signatureText}</div>

				</>
			)}

		</div>
	);
}