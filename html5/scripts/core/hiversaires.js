"use strict";

class Hiversaires {
  constructor() {
    this.element = document.createElement("hiversaires");
    document.body.appendChild(this.element);
    window.hiversaires = this;
    window.hh = this;
    this.keyboard = new Keyboard(this.responder.bind(this));
    this.artBook = new ArtBook();
    this.game = new Game();
    this.music = new Music();
    this.stage = new Stage(this.element, this.responder.bind(this));
    this.interface = new Interface();
    this.walkthrough = new Walkthrough(this.responder.bind(this));
  }

  start() {
    this.stage.start();
    this.game.start();
    this.refreshNode();
    this.interface.showHomeMenu();
  }

  get currentNode() {
    return nodesByID.get(this.game.userNodeID);
  }

  get currentSubject() {
    return this.currentNode.subjects[this.game.userOrientation];
  }

  get currentPuzzle() {
    const subject = this.currentSubject;
    if (subject != null && subject.type == SubjectType.puzzle) {
      return puzzlesByID.get(subject.puzzleID);
    }
    return null;
  }

  get currentSeals() {
    return this.game.puzzleState.seals;
  }

  get currentFuses() {
    return this.game.puzzleState.fuses;
  }

  responder(input) {
    if (this.game.userChapter == Chapter.credit) {
      return;
    }

    if (DEBUG_LOG_INPUT) {
      console.log(input);
    }

    switch (input) {
      case Input.left:
        this.moveLeft();
        break;
      case Input.right:
        this.moveRight();
        break;
      case Input.forward:
        this.moveForward();
        break;
      case Input.back:
        this.moveBackward();
        break;
      case Input.action:
        this.action();
        break;
      case Input.center:
        if (this.currentPuzzle != null && this.currentPuzzle.active) {
          this.action();
        } else {
          this.moveForward();
        }
        break;
    }
  }

  refreshNode() {
    this.interface.hideMenu();
    this.stage.billboard("modifier").alpha = 0;
    this.stage.billboard("clockFace").alpha = 0;
    this.stage.billboard("clockShadow").alpha = 0;
    this.stage.billboard("progressPane").alpha = 0;
    this.stage.billboard("ententeScreen").alpha = 0;
    this.stage.billboard("illusion").alpha = 0;

    this.stage.trigger("action").hidden = true;
    this.stage.billboard("modifier").hidden = true;

    this.stage.trigger("moveForward").hidden =
      this.currentSubject.type == SubjectType.none;

    this.stage.billboard("viewMain").image =
      "node/" + this.game.userNodeID + "." + this.game.userOrientation + ".jpg";

    if (Math.random() < 0.3 && this.currentSubject.illusionID != null) {
      puzzlesByID.get(this.currentSubject.illusionID).appear();
    }

    let lastPuzzle = null;
    while (this.currentPuzzle != null && lastPuzzle != this.currentPuzzle) {
      lastPuzzle = this.currentPuzzle;
      lastPuzzle.setup();
    }
    this.stage.trigger("action").hidden = !(
      this.currentPuzzle != null && this.currentPuzzle.active
    );
    this.music.setAmbience(ambienceByZone.get(this.currentNode.zone));

    if (DEBUG_PRINT_INFO) {
      console.log(
        "at",
        this.game.userNodeID,
        "facing",
        this.game.userOrientation,
        "toward",
        this.currentSubject
      );
    }

    this.updateMusic();
  }

  updateMusic() {
    this.music.setRecord(recordsByChapter.get(this.game.userChapter));
  }

  moveLeft() {
    this.music.playEffect("footstep_turn");
    this.game.userOrientation = (this.game.userOrientation + 4 - 1) % 4;
    this.stage.animateTurnLeft();
    this.refreshNode();
  }

  moveRight() {
    this.music.playEffect("footstep_turn");
    this.game.userOrientation = (this.game.userOrientation + 4 + 1) % 4;
    this.stage.animateTurnRight();
    this.refreshNode();
  }

  moveForward() {
    if (this.currentSubject.type == SubjectType.node) {
      this.playFootStep();
      const { nodeID, orientation } = this.currentSubject;
      this.game.userNodeID = nodeID;
      if (orientation != null) {
        this.game.userOrientation = orientation;
      }
    } else {
      this.music.playEffect("footstep_collide");
    }

    this.stage.animateStepForward();
    this.refreshNode();
  }

  moveBackward() {
    this.music.playEffect("footstep_turn");

    this.game.userOrientation = (this.game.userOrientation + 2) % 4;
    this.refreshNode();

    if (this.currentSubject.type == SubjectType.node) {
      const { nodeID, orientation } = this.currentSubject;
      this.game.userNodeID = nodeID;
      if (orientation != null) {
        this.game.userOrientation = orientation;
      }
    } else if (this.currentSubject.type == SubjectType.puzzle) {
      if (this.currentSubject.puzzleType == PuzzleType.door) {
        // As long as it's active, perform the door's action until you walked through it
        const lastSubject = this.currentSubject;
        while (
          this.currentSubject == lastSubject &&
          this.currentPuzzle.active
        ) {
          this.currentPuzzle.performAction();
        }
      }
    }

    this.game.userOrientation = (this.game.userOrientation + 2) % 4;
    this.refreshNode();

    this.stage.animateStepBackward();
  }

  warpTo(node, orientation) {
    this.game.userNodeID = node;
    this.game.userOrientation = orientation % 4;
    this.refreshNode();
  }

  action() {
    if (this.currentPuzzle != null && this.currentPuzzle.active) {
      this.currentPuzzle.performAction();
    }
  }

  setModifier(modifier) {
    this.stage.billboard("modifier").image = this.modifierToURL(modifier);
  }

  preloadModifier(modifier) {
    this.artBook.preloadArt("media/graphics/" + this.modifierToURL(modifier));
  }

  modifierToURL(modifier) {
    return (
      "node/" +
      this.game.userNodeID +
      "." +
      this.game.userOrientation +
      "." +
      modifier +
      ".jpg"
    );
  }

  showModifier(fadeDuration = 0, fadeDelay = 0) {
    this.stage.billboard("modifier").hidden = false;
    this.stage.fadeIn(
      this.stage.billboard("modifier"),
      fadeDuration,
      fadeDelay
    );
  }

  hideModifier(fadeDuration = 0, fadeDelay = 0) {
    this.stage.billboard("modifier").hidden = false;
    this.stage.fadeOut(
      this.stage.billboard("modifier"),
      fadeDuration,
      fadeDelay
    );
  }

  playFootStep() {
    this.game.userFootstep += 1;
    this.music.playEffect(
      this.game.userFootstep % 2 == 1 ? "footstep_left" : "footstep_right"
    );
  }
}
