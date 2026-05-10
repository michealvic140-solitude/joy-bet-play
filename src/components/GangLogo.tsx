import { cn } from "@/lib/utils";

/**
 * Premium animated "gang shield" emblem for LSL.
 * Crossed pistols inside a hex shield, gold + emerald gradient, idle glow + slow rotate ring.
 */
export function GangLogo({ className, size = 32, withGlow = true }: { className?: string; size?: number; withGlow?: boolean }) {
  return (
    <span className={cn("relative inline-grid place-items-center", className)} style={{ width: size, height: size }} aria-hidden>
      {withGlow && (
        <span
          className="absolute inset-[-25%] rounded-full blur-xl opacity-60 animate-pulse-glow pointer-events-none"
          style={{ background: "radial-gradient(closest-side, oklch(0.82 0.17 90 / 0.55), transparent 70%)" }}
        />
      )}
      {/* Slowly rotating outer ring */}
      <svg
        viewBox="0 0 100 100"
        className="absolute inset-0 animate-slow-spin"
        style={{ filter: "drop-shadow(0 0 6px oklch(0.82 0.17 90 / 0.45))" }}
      >
        <defs>
          <linearGradient id="lslRing" x1="0" x2="1" y1="0" y2="1">
            <stop offset="0%" stopColor="oklch(0.82 0.17 90)" />
            <stop offset="50%" stopColor="oklch(0.65 0.17 158)" />
            <stop offset="100%" stopColor="oklch(0.62 0.14 80)" />
          </linearGradient>
        </defs>
        <circle cx="50" cy="50" r="46" fill="none" stroke="url(#lslRing)" strokeWidth="1.6" strokeDasharray="3 6" />
      </svg>
      {/* Static shield + crossed pistols */}
      <svg viewBox="0 0 100 100" className="relative">
        <defs>
          <linearGradient id="lslShield" x1="0" x2="0" y1="0" y2="1">
            <stop offset="0%" stopColor="oklch(0.18 0.05 165)" />
            <stop offset="100%" stopColor="oklch(0.12 0.04 270)" />
          </linearGradient>
          <linearGradient id="lslGold" x1="0" x2="1" y1="0" y2="1">
            <stop offset="0%" stopColor="oklch(0.92 0.15 92)" />
            <stop offset="100%" stopColor="oklch(0.62 0.14 80)" />
          </linearGradient>
          <linearGradient id="lslEmerald" x1="0" x2="1" y1="0" y2="1">
            <stop offset="0%" stopColor="oklch(0.78 0.16 160)" />
            <stop offset="100%" stopColor="oklch(0.55 0.16 158)" />
          </linearGradient>
        </defs>
        {/* Hex shield */}
        <path
          d="M50 8 L86 24 L86 60 Q86 78 50 92 Q14 78 14 60 L14 24 Z"
          fill="url(#lslShield)"
          stroke="url(#lslGold)"
          strokeWidth="2.2"
        />
        {/* Inner ring */}
        <path
          d="M50 16 L78 28 L78 58 Q78 73 50 84 Q22 73 22 58 L22 28 Z"
          fill="none"
          stroke="url(#lslEmerald)"
          strokeWidth="1"
          opacity="0.7"
        />
        {/* Crossed pistols (stylised) */}
        <g transform="translate(50 52) rotate(-30)" stroke="url(#lslGold)" strokeWidth="2.4" strokeLinecap="round" fill="none">
          <line x1="-22" y1="0" x2="14" y2="0" />
          <path d="M14 -1 L20 -4 L22 -1 L20 3 L14 1 Z" fill="url(#lslGold)" stroke="none" />
          <line x1="-10" y1="0" x2="-14" y2="8" />
        </g>
        <g transform="translate(50 52) rotate(30)" stroke="url(#lslEmerald)" strokeWidth="2.4" strokeLinecap="round" fill="none">
          <line x1="-22" y1="0" x2="14" y2="0" />
          <path d="M14 -1 L20 -4 L22 -1 L20 3 L14 1 Z" fill="url(#lslEmerald)" stroke="none" />
          <line x1="-10" y1="0" x2="-14" y2="8" />
        </g>
        {/* Star pivot */}
        <circle cx="50" cy="52" r="3.5" fill="url(#lslGold)" />
        {/* Banner letters */}
        <text x="50" y="30" textAnchor="middle" fontFamily="Cinzel, serif" fontWeight="800" fontSize="11" fill="url(#lslGold)" letterSpacing="2">
          LSL
        </text>
      </svg>
    </span>
  );
}
