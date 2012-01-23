function Player() {
    this.currentlyPlayingSong = null;
    this.isPlaying = false;
}

Player.prototype = {
    constructor: Player,

    play: function (song) {
        this.currentlyPlayingSong = song;
        this.resume();
    },

    pause: function () {
        this.isPlaying = false;
    },

    resume: function () {
        if (this.isPlaying) {
            throw new Error("song is already playing");
        } else if (this.currentlyPlayingSong === null) {
            throw new Error("no song to played");
        } else {
            this.isPlaying = true;
        }
    },

    makeFavourite: function () {
        this.currentlyPlayingSong.persistFavoriteStatus(true);
    }
};

//Player.prototype.play = function(song) {
  //this.currentlyPlayingSong = song;
  //this.isPlaying = true;
//};

//Player.prototype.pause = function() {
  //this.isPlaying = false;
//};

//Player.prototype.resume = function() {
  //if (this.isPlaying) {
    //throw new Error("song is already playing");
  //}

  //this.isPlaying = true;
//};

//Player.prototype.makeFavorite = function() {
  //this.currentlyPlayingSong.persistFavoriteStatus(true);
//};
