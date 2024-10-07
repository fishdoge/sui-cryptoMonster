import Image from "next/image";
import localFont from "next/font/local";
//import { ConnectWallet } from "@/component/connectWallet"
import { ConnectButton, useAccounts   } from '@mysten/dapp-kit';

const geistSans = localFont({
  src: "./fonts/GeistVF.woff",
  variable: "--font-geist-sans",
  weight: "100 900",
});
const geistMono = localFont({
  src: "./fonts/GeistMonoVF.woff",
  variable: "--font-geist-mono",
  weight: "100 900",
});

export default function Home() {
  const accounts = useAccounts ();


  return (
    <div
      className={`${geistSans.variable} ${geistMono.variable} grid grid-rows-[20px_1fr_20px] items-center justify-items-center min-h-screen p-8 pb-20 gap-16 sm:p-20 font-[family-name:var(--font-geist-sans)]`}
    >
      <main className="flex flex-col gap-8 row-start-2 items-center sm:items-start">
        <div className="absolute inset-0 h-[300px] bg-black transform -skew-y-6 origin-top-left"></div>
          <div className="absolute inset-0 flex items-center justify-center">
            <div className="text-center mt-10">

              <span className="text-2xl md:text-3xl font-sans text-black">Sui monster</span>
            </div>
        </div>

        <div className="-ml-20">
          <Image
            src="/sui-web3-monster.png"
            width={250}
            height={250}
            alt="Picture of the author"
          />
        </div>

        <div className="text-2xl	 text-black">This is the sui monster! The Defi gamming plateform</div>
        <ConnectButton/>
        <ul>
          {accounts.map((account) => (
            <li key={account.address}>- {account.address}</li>
          ))}
			  </ul>
      </main>
      <footer className="w-full h-[40px] row-start-3 flex gap-6 flex-wrap items-center justify-center bg-slate-500">
        <a
          className="flex items-center gap-2 hover:underline hover:underline-offset-4 text-cyan-50"
          href="https://nextjs.org/learn?utm_source=create-next-app&utm_medium=default-template-tw&utm_campaign=create-next-app"
          target="_blank"
          rel="noopener noreferrer"
        >
          <Image
            aria-hidden
            src="https://nextjs.org/icons/file.svg"
            alt="File icon"
            width={16}
            height={16}
          />
          Learn
        </a>
        <a
          className="flex items-center gap-2 hover:underline hover:underline-offset-4 text-cyan-50"
          href="https://vercel.com/templates?framework=next.js&utm_source=create-next-app&utm_medium=default-template-tw&utm_campaign=create-next-app"
          target="_blank"
          rel="noopener noreferrer"
        >
          <Image
            aria-hidden
            src="https://nextjs.org/icons/window.svg"
            alt="Window icon"
            width={16}
            height={16}
          />
          Examples
        </a>
        <a
          className="flex items-center gap-2 hover:underline hover:underline-offset-4 text-cyan-50"
          href="https://github.com/fishdoge/sui-cryptoMonster/tree/main"
          target="_blank"
          rel="noopener noreferrer"
        >
          <Image
            aria-hidden
            src="https://nextjs.org/icons/globe.svg"
            alt="Globe icon"
            width={16}
            height={16}
          />
          Go to github →
        </a>
      </footer>
    </div>
  );
}
