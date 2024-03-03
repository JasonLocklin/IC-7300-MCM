# IC-7300-MCM
 Icom 7300 Missing Compute Module

## Roadmap
- [ ] WFView Server system service
- [ ] Timekeep System service
- [ ] CAT logging system service
- [ ] Shutdown on radio poweroff system service
- [ ] Tmux console on boot
- [ ] Tmux radio environment
- [ ] Universal keyboard shortcuts/morse sending
- [ ] VNC desktop (not running unless needed)
- [ ] Software install script

## Power Options
Undecided. Either:

1. Power off ACC pin. 
  * Power will be cut when radio turns off. 
  * Configure like pi-star with RO system partition and toggle switch for sysadmin tasks.
  * Use a logging partition that is RW. 
2. Power off side of power jack.
  * Power will remain on when radio is shut off.
  * Can do safe shut down when radio is shut off.
  * Can potentially start radio if pi is left running.
  * Will boot immediately on power up, possibly before radio starts.
  * Can get away without RO OS partition IF CAREFUL. May still need it in practice.

## WFView server
It would be ideal to run this always, but a. this is beta software right now, and b. this 
would prevent me from CW keying from the terminal for now. When these issues resolve, it can
be a 24/7 service.


