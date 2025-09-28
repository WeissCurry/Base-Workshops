import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  webpack: (config) => {
    config.externals.push("pino-pretty", "lokijs", "encoding");
    return config;
  },
  // async redirects() {
  //   return [
  //     {
  //       source: "/.well-known/farcaster.json",
  //       destination: "https://api.farcaster.xyz/miniapps/hosted-manifest/01998e94-09ab-f8a2-fabf-48c751c62264",
  //       permanent: false,
  //     },
  //   ];
  // },
};

export default nextConfig;
