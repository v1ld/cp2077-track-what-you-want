@replaceMethod(WorldMapMenuGameController)
  private final func TryTrackQuestOrSetWaypoint() -> Void {
    // v1ld: set up the journal.TrackEntry(dummy) calls below which is how we untrack the journal quest 
    let journal: ref<JournalManager> = GameInstance.GetJournalManager(this.GetOwner().GetGame());
    let dummy: wref<JournalEntry>;
    if this.IsFastTravelEnabled() {
      return;
    };
    if this.selectedMappin != null {
      if this.selectedMappin.IsInCollection() && this.selectedMappin.IsCollection() || !this.selectedMappin.IsInCollection() {
        if this.CanQuestTrackMappin(this.selectedMappin) {
          // v1ld: unconditionally untrack any custom mappins since we're setting a quest mappin
          this.UntrackCustomPositionMappin();
          if !this.IsMappinQuestTracked(this.selectedMappin) {
            // this.UntrackCustomPositionMappin();
            this.TrackQuestMappin(this.selectedMappin);
            this.PlaySound(n"MapPin", n"OnEnable");
          };
        } else {
          if this.CanPlayerTrackMappin(this.selectedMappin) {
            if this.selectedMappin.IsCustomPositionTracked() {
              this.UntrackCustomPositionMappin();
              this.SetSelectedMappin(null);
              this.PlaySound(n"MapPin", n"OnDisable");
            } else {
              if this.selectedMappin.IsPlayerTracked() {
                this.UntrackMappin();
                this.PlaySound(n"MapPin", n"OnDisable");
              } else {
                // v1ld: untrack the journal quest
                journal.TrackEntry(dummy);
                this.UntrackCustomPositionMappin();
                this.TrackMappin(this.selectedMappin);
                this.PlaySound(n"MapPin", n"OnEnable");
              };
            };
          };
        };
        this.UpdateSelectedMappinTooltip();
      };
    } else {
      // v1ld: untrack the journal quest
      journal.TrackEntry(dummy);
      this.TrackCustomPositionMappin();
    };
    this.PlaySound(n"MapPin", n"OnCreate");
  }