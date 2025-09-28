const ROOT_URL =
  process.env.NEXT_PUBLIC_URL ||
  (process.env.VERCEL_URL && `https://${process.env.VERCEL_URL}`) ||
  "http://localhost:3000";

/**
 * MiniApp configuration object. Must follow the mini app manifest specification.
 *
 * @see {@link https://docs.base.org/mini-apps/features/manifest}
 */
export const minikitConfig = {
  accountAssociation: {
    header: "eyJmaWQiOjEzNTYwODgsInR5cGUiOiJjdXN0b2R5Iiwia2V5IjoiMHgyOWM1ZkJkMzkxM0UxYjE2QjhmNDBmMUM0NDFFN2RhN2Q5NjIwMjBFIn0",
    payload: "eyJkb21haW4iOiJtaW5pa2l0Lm5ldGxpZnkuYXBwIn0",
    signature: "MHhjMTFhNTI0YzViZDA5ODM3MDAwNGY4Njg3ZGZmMmY5Mjg1N2QzMzY4NmI4YWI1ZTI5NDg2OTE0M2ZjYzIwOTEwNDg2N2FiOTRmZDBlYzk1ZmEwODAzOGMyNmRiN2QwNTMxNmI3OGFkNWUwZDhkYjA3ODIyYzRiZmY5YTdiYWJlZTFj",
  },
  baseBuilder: {
    allowedAddresses: ["0xE99C4D4692bBB420218c5cB4606d8a917CD8A312"],
  },
  miniapp: {
    version: "1",
    name: "my-minikit-app",
    subtitle: "",
    description: "",
    screenshotUrls: [],
    iconUrl: `${ROOT_URL}/icon.png`,
    splashImageUrl: `${ROOT_URL}/splash.png`,
    splashBackgroundColor: "#000000",
    homeUrl: ROOT_URL,
    webhookUrl: `${ROOT_URL}/api/webhook`,
    primaryCategory: "utility",
    tags: ["example"],
    heroImageUrl: `${ROOT_URL}/hero.png`,
    tagline: "",
    ogTitle: "",
    ogDescription: "",
    ogImageUrl: `${ROOT_URL}/hero.png`,
  },
} as const;
