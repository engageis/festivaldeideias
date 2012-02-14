# Sets the differ output to html. Ex:
# @original = "Epic lolcat fail!"
# @current  = "Epic wolfman fail!"
# @diff = Differ.diff_by_word(@current, @original)
#  => Epic <del class="differ">lolcat</del><ins class="differ">wolfman</ins> fail!
Differ.format = :html