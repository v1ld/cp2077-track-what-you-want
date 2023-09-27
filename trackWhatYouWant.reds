/* Track What You Want; (c) v1ld, 2022-03-13
 * MIT License applies
 */

@replaceMethod(WorldMapMenuGameController)
  private final func TryTrackQuestOrSetWaypoint() -> Void {
    // v1ld: set up how we untrack the journal quest with journal.TrackEntry(dummy) calls below  
    let journal: ref<JournalManager> = GameInstance.GetJournalManager(this.GetOwner().GetGame());
    let dummy: wref<JournalEntry>;
    if this.IsFastTravelEnabled() {
      return;
    };
    if this.selectedMappin != null {
      if this.selectedMappin.IsInCollection() && this.selectedMappin.IsCollection() || !this.selectedMappin.IsInCollection() {
        if this.CanQuestTrackMappin(this.selectedMappin) {
          // v1ld: unconditionally untrack any other mappins since we're setting a quest mappin
          // quest mappins also include gigs, vehicles and apartments
          this.UntrackMappin();
          if !this.IsMappinQuestTracked(this.selectedMappin) {
            this.UntrackCustomPositionMappin();
            this.TrackQuestMappin(this.selectedMappin);
            this.PlaySound(n"MapPin", n"OnEnable");
            this.PlayRumble(RumbleStrength.SuperLight, RumbleType.Slow, RumblePosition.Right);
          };
        } else {
          if this.CanPlayerTrackMappin(this.selectedMappin) {
            if this.selectedMappin.IsCustomPositionTracked() {
              this.UntrackCustomPositionMappin();
              this.SetSelectedMappin(null);
              this.PlaySound(n"MapPin", n"OnDisable");
              this.PlayRumble(RumbleStrength.SuperLight, RumbleType.Pulse, RumblePosition.Right);
            } else {
              if this.selectedMappin.IsPlayerTracked() {
                this.UntrackMappin();
                this.PlaySound(n"MapPin", n"OnDisable");
                this.PlayRumble(RumbleStrength.SuperLight, RumbleType.Pulse, RumblePosition.Right);
              } else {
                // v1ld: untrack the journal quest, this is a non-journal quest mappin type
                journal.TrackEntry(dummy);
                this.UntrackCustomPositionMappin();
                this.TrackMappin(this.selectedMappin);
                this.PlaySound(n"MapPin", n"OnEnable");
                this.PlayRumble(RumbleStrength.SuperLight, RumbleType.Slow, RumblePosition.Right);
              };
            };
          };
        };
        this.UpdateSelectedMappinTooltip();
      };
    } else {
      // v1ld: untrack the journal quest, we're setting a custom mapping in a random spot
      journal.TrackEntry(dummy);
      this.TrackCustomPositionMappin();
    };
    this.PlaySound(n"MapPin", n"OnCreate");
  }