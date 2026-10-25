'use client';
import Link from 'next/link';
export default function Header(){return <header className="site-header"><Link className="brand" href="/"><span className="brand-mark">⌂</span><span>MYHOME FINDER<small>YOUR PROPERTY. YOUR FUTURE.</small></span></Link><nav><Link href="/">Home</Link><Link href="/properties">Properties</Link><Link href="/flats">Flats</Link><Link href="/houses">Houses</Link><Link href="/plots">Plots</Link><Link href="/about">About</Link><Link href="/contact">Contact</Link></nav><Link className="button small-button" href="/contact">Enquire ↗</Link></header>}
