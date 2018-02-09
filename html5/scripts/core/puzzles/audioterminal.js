class AudioTerminal extends Puzzle {
  constructor(id, info, defaultState) {
    super(id, info, defaultState);
  }

  setup() {
    hiversaires.templateVignette();
    hiversaires.setCurrentAction(
      function() {
        hiversaires.game.puzzleState[hiversaires.currentPuzzle.id] =
          (hiversaires.game.puzzleState[hiversaires.currentPuzzle.id] + 1) % 2;
        this.templateAudioUpdate();
      }.bind(this)
    );

    this.templateAudioUpdate();
  }

  templateAudioUpdate() {
    hiversaires.templateAudioInterface();
    if (hiversaires.game.puzzleState[hiversaires.currentPuzzle.id] == 1) {
      hiversaires.setModifier("on");
      hiversaires.showModifier(0.3, 0.1);
      hiversaires.music.volume = 1;
    } else {
      hiversaires.hideModifier(0.3, 0);
      hiversaires.music.volume = 0;
    }
  }
}