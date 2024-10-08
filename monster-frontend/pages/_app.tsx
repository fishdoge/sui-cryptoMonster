import "@/styles/globals.css";
//import type { AppProps } from "next/app";
import { createNetworkConfig, SuiClientProvider, WalletProvider } from '@mysten/dapp-kit';
import { getFullnodeUrl } from '@mysten/sui/client';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import '@mysten/dapp-kit/dist/index.css';
import Home from './index'



const { networkConfig } = createNetworkConfig({
	localnet: { url: getFullnodeUrl('localnet') },
	mainnet: { url: getFullnodeUrl('mainnet') },
	devnet:{url: 'https://fullnode.devnet.sui.io:443' }
});

const queryClient = new QueryClient();

export default function App() {
	return (

		<QueryClientProvider client={queryClient}>
			<SuiClientProvider networks={networkConfig} defaultNetwork="devnet">
				<WalletProvider>

					<Home/>
				</WalletProvider>
			</SuiClientProvider>
		</QueryClientProvider>


	);
}
