
#need to add piece promotion
#could add status messages, e.g. "white moved knight from b1 to c3.  white captured black pawn"
#

class Array
  #use to get destination
  def plus other
    return [self[0]+other[0],self[1]+other[1]]
  end

  #use to reconstitute vector
  def minus other
    return [self[0]-other[0],self[1]-other[1]]
  end
end


module Chess

#a1 = [0,0]
#h1 = [0,7]
#a8 = [7,0]
#h8 = [7,7]
#
#row number first, then column number
#
#

  #def make_square_hash
  #    dictionary = {}
  #    "a".upto("h").with_index{|letter,index2|
  #      "1".upto("8").with_index{|number,index1|
  #       dictionary["#{letter}#{number}".to_sym] = [index1,index2]
  #      }
  #    }
  #  return dictionary
  #end

  SQUARE_HASH = {}
  "a".upto("h").with_index{|letter,index2|
    "1".upto("8").with_index{|number,index1|
      SQUARE_HASH["#{letter}#{number}".to_sym] = [index1,index2]
    }
  }

  #make_square_hash
  WHITE = "white"
  BLACK = "black"
  QUEENSIDE = [0,-2]
  KINGSIDE = [0,2]










  class Move
    #create a move and add information to it.  then append it to an array of previous moves so there's a history
    attr_accessor :startSquare, :destSquare, :capturedPiece, :movedPiece
  end

  class Castle < Move
    attr_accessor :rookStartSquare, :rookDestSquare, :rookMoved
  end

  class EnPassante < Move
  end




  class Player
    attr_accessor :color
    
    def initialize(color)
      @color = color
    end

    def to_s
      color
    end

  end

  class Human < Player
    def prompt_player_for_move
      move = Array.new(2)

      loop do
        puts "#{color} player: please select a piece to move by typing in its square (e.g., 'c2')"
        move[0] = gets.chomp.to_sym
        break if SQUARE_HASH.keys.include?(move[0])
      end

      loop do
        puts "#{color} player: please enter a new square to move to (e.g., 'd2')"
        move[1] = gets.chomp.to_sym
        break if SQUARE_HASH.keys.include?(move[1])
      end

      return move
    end

  end

  class Computer < Player

  end


  class Piece
    attr_accessor :moves, :position, :vectors, :moved, :captured, :color
    attr_reader :player

    def initialize (position,color)
      @color = color
      @position = position
      @captured = false
      @moved = false
    end

    def captured?
      return @captured
    end

    def moved?
      return @moved
    end

    def jumps?
      return false
    end

    def moves
      #update the list of moves.
      #does not check validity
      start = SQUARE_HASH[self.position]
      vectors.select{|vector|
        !(destination = SQUARE_HASH.key(start.plus(vector)).nil?)
      }.map{ |vector|
        move = [self.position,SQUARE_HASH.key(start.plus(vector))]
      }
    end

    def special_moves
      return []
    end
  end

  class Knight < Piece

    def initialize *args
      @vectors = [[1,2],
                      [1,-2],
                      [-1,2],
                      [-1,-2],
                      [2,1],
                      [2,-1],
                      [-2,1],
                      [-2,-1]
                    ]
      super
    end

    def jumps?
      return true
    end

    def to_s
      return color == WHITE ? "\u2658" : "\u265E"
    end

  end

  class Pawn < Piece
    attr_reader :enPassanteVectors

    def initialize position,color
      @direction
      if color == WHITE
        @enPassanteVectors = [[1,1],[1,-1]]
        @direction = 1
      else
        @enPassanteVectors = [[-1,1],[-1,-1]]
        @direction = -1
      end
      super
    end

    def vectors
      return [[@direction,0]] if moved?
      return [[1*@direction,0],[2*@direction,0]]
    end

    def to_s
      return color == WHITE ? "\u2659" : "\u265F"
    end

    def special_moves
      #update the list of moves.
      #does not check validity
      start = SQUARE_HASH[self.position]
      enPassanteVectors.select{|vector|
        !(destination = SQUARE_HASH.key(start.plus(vector)).nil?)
      }.map{ |vector|
        move = [self.position,SQUARE_HASH.key(start.plus(vector))]
      }
    end
  end

  class King < Piece
    attr_reader :castleVectors

    def initialize *args
      @vectors = [[0,1],
                  [1,1],
                  [1,0],
                  [1,-1],
                  [0,-1],
                  [-1,-1],
                  [-1,0],
                  [-1,1]]
      @castleVectors = [QUEENSIDE,KINGSIDE]
      super
    end

    def special_moves
      #update the list of moves.
      #does not check validity
      start = SQUARE_HASH[self.position]
      castleVectors.select{|vector|
        !(destination = SQUARE_HASH.key(start.plus(vector)).nil?)
      }.map{ |vector|
        move = [self.position,SQUARE_HASH.key(start.plus(vector))]
      }
    end

    def to_s
      return color == WHITE ? "\u2654" : "\u265A"
    end

  end

  class Queen < Piece

    def to_s
      return color == WHITE ? "\u2655" : "\u265B"
    end

    def vectors
      vctrs = []
      1.upto(7) {|x|
        vctrs << [0,x]
        vctrs << [0,-x]
        vctrs << [x,0]
        vctrs << [-x,0]
        vctrs << [x,x]
        vctrs << [x,-x]
        vctrs << [-x,x]
        vctrs << [-x,-x]
      }
      return vctrs
    end


  end

  class Bishop < Piece

    def to_s
      return color == WHITE ? "\u2657" : "\u265D"
    end

    def vectors
    vctrs = []
    1.upto(7) { |x|
      vctrs << [x,x]
      vctrs << [x,-x]
      vctrs << [-x,x]
      vctrs << [-x,-x]
    }
    return vctrs
    end
  end

  class Rook < Piece
    attr_reader :castleVectors

    def initialize *args
      if position == :a1 || position == :a8
        @castleVectors = [[3,0]]
      else
        @castleVectors = [[-2,0]]
      end
      super
    end

    def to_s
      return color == WHITE ? "\u2656" : "\u265C"
    end
    def vectors
      vctrs = []
      1.upto(7) {|x|
        vctrs << [0,x]
        vctrs << [0,-x]
        vctrs << [x,0]
        vctrs << [-x,0]
      }
      return vctrs
    end



  end

  class Square
    #square constructor has to know where each piece belongs
    #
    attr_accessor :piece, :color, :id

    def initialize(id, color)
      @id = id
      @color = color
      case id
      when :a1,:h1
        @piece = Rook.new(id,WHITE)
      when :b1,:g1
        @piece = Knight.new(id,WHITE)
      when :c1,:f1
        @piece = Bishop.new(id,WHITE)
      when :d1
        @piece = Queen.new(id,WHITE)
      when :e1
        @piece = King.new(id,WHITE)
      when :a2,:b2,:c2,:d2,:e2,:f2,:g2,:h2
        @piece = Pawn.new(id,WHITE)
      when :a7,:b7,:c7,:d7,:e7,:f7,:g7,:h7
        @piece = Pawn.new(id,BLACK)
      when :a8,:h8
        @piece = Rook.new(id,BLACK)
      when :b8,:g8
        @piece = Knight.new(id,BLACK)
      when :c8,:f8
        @piece = Bishop.new(id,BLACK)
      when :d8
        @piece = Queen.new(id,BLACK)
      when :e8
        @piece = King.new(id,BLACK)
      else
        @piece = nil
      end
    end

    def add_piece! piece
      #add the piece to the square, and return a refrence to the piece
      return nil if piece.nil?
      @piece = piece
      @piece.position = @id
      return @piece
    end

    def remove_piece!
      #remove the piece from the square, and return a reference to the piece
      return nil if piece.nil?
      @piece.position = nil
      piece_ref = @piece
      @piece = nil
      return piece_ref
    end


    def empty?
      return @piece.nil?
    end

    def opposing_piece? color
      return false if empty?
      return color != @piece.color
    end

    def minus other
      #return a vector that is the difference between self and other
      selfVector = SQUARE_HASH[self.id]
      otherVector = SQUARE_HASH[other.id]
      return selfVector.minus(otherVector)
    end

    def plus other
      selfVector = SQUARE_HASH[self.id]
      otherVector = other.is_a?(Square) ? SQUARE_HASH[other.id] : other
      return selfVector.plus(otherVector)
    end

    def rank
      return SQUARE_HASH[id][0]+1
    end

    def file
      return "a".upto("h").with_index do |letter,index| return letter if SQUARE_HASH[id][1] == index end 
    end

    def to_s
      if empty?
        return color == WHITE ? "\u2591" : " "
      else
        return @piece.to_s
      end
    end

  end

  class Game
    attr_accessor :squares, :players, :active_player, :previousMove

    def initialize(white=Human.new(WHITE),black=Human.new(BLACK))
      @players = []
      @players << white
      @players << black
      @active_player = @players[0]
      @squares = []
      color = WHITE

      "1".upto("8").reverse_each do |number|
        "a".upto("h") do |letter|
          symbol = "#{letter}#{number}".to_sym
          square = Square.new(symbol,color)
          @squares << square
          color = color == WHITE ? BLACK : WHITE
        end
        color = color == WHITE ? BLACK : WHITE
      end
      #set up the board
    end

    def get_square squareSymbol
      #get the square object from the provided square symbol or vector
      return squareSymbol.is_a?(Symbol) ? squares.find{ |square| square.id == squareSymbol} : squares.find{ |square| square.id == SQUARE_HASH.key(squareSymbol)}
    end

    def square_from_here position,vector
      #take in a starting position and a vector, return the square the vector is pointing at
      #return nil if new square is outside the board

      if position.is_a?(Symbol)
        position = SQUARE_HASH[position]
      end

      new_position = position.plus(vector)
      return get_square(SQUARE_HASH.key(new_position))
    end

    def squares_from_here position,vector
      #return all of the squares between position and vector's target, including the destination
      return nil unless square_from_here position,vector
      squaresFromHere = []

      x_mult = vector[0] <=> 0
      y_mult = vector[1] <=> 0

      1.upto([vector[0].abs,vector[1].abs].max) {
        |x| squaresFromHere << square_from_here(position,[x*x_mult,x*y_mult])
      }
      return squaresFromHere
    end



    def pieces
      #get the pieces when we need them
      piecesArray = []
      @squares.each{|square|
        piecesArray << square.piece unless square.empty?
      }
      return piecesArray
    end

    def self.create_game
      return Game.new
    end

    def play_game

      until checkmate? || stalemate?

        display_board

        display_check_warning if check?


        move = active_player.prompt_player_for_move
        #returns [:a1,:a3], e.g.
        until valid_move?(move) && out_of_check?(move)
          display_invalid_move_warning
          move = active_player.prompt_player_for_move
        end
        #create_move

        if castle?(move)
          castle(move)
        elsif en_passante?(move)
          en_passante(move)
        else
          perform_move(move)
        end

        promote get_square(move[1]).piece if promote? get_square(move[1]).piece

        @previousMove = move

        change_player
      end

      display_board

      if checkmate?
        #active_player lost
        display_checkmate_message
      else
        display_stalemate_message
      end

    end


    def display_check_warning
      puts "You are in check!  You must pick a move that gets you out of check."
    end

    def display_invalid_move_warning
      puts "You have selected an invalid move.  Please try again."

    end

    def display_checkmate_message
      puts "Congratulations #{other_player}, you have defeated #{active_player}!"
    end

    def display_stalemate_message
      puts "The game ended in a stalemate!"
    end

    def display_board
      puts "  -----------------"
      index = 0
      "1".upto("8").reverse_each { |number|
        print "#{number} |"
        "a".upto("h"){
          print "#{squares[index]}|"
          index += 1
        }
        puts ""
      }
      puts "   a b c d e f g h "
    end


    def checkmate?
      #this is checked at the start of a turn,
      #so it should check the active_player's king vs other_player's pieces

      return false unless check?

      # check + stalemate = checkmate
      return stalemate?
    end


    def stalemate?
      #only checking stalemates caused by a lack of available moves
      return pieces.filter{ |piece|
        piece.color == active_player.color
      }.all? {|piece|
        piece.moves.none? { |move|
          valid_move?(move) && out_of_check?(move)
        }
      }
    end

    def display_nil_square_message squareSymbol
      puts "#{squareSymbol} is not a valid square.  please choose from a1 through h8"
      return true
    end

    def display_empty_square_message squareSymbol
      puts "#{squareSymbol} is an empty square.  Please pick a square with a #{active_player} piece in it"
      return true
    end

    def display_wrong_color_message
      puts "#{}"
    end




    def valid_move?(move,color=@active_player.color)
      start = move[0]
      destination = move[1]

      #first make sure there's a piece to move
      square = get_square(start)
      
      return false if square.nil?

      return false if square.empty?


      #then make sure the destination exists
      destSquare = get_square(destination)

      return false if destSquare.nil?


      #then make sure the piece is the active_player's color
      
      piece = square.piece
      return false unless color == piece.color


      #then make sure the piece could move in that way
      return false unless piece.moves.include?(move) || piece.special_moves.include?(move)

      #make sure a pawn isn't trying to attack straight ahead
      return false if piece.is_a?(Pawn) && piece.moves.include?(move) && !destSquare.empty?

      #make sure there's nothing in the way of the piece.
      
      vector = SQUARE_HASH[destination].minus(SQUARE_HASH[start])
      return false if vector.nil?

      path = []
      if piece.jumps?
        path << destSquare
      else
        path = squares_from_here(piece.position,vector)
      end
      return false unless path_clear?(path,color)


      #handle castling
      if piece.is_a?(King) && piece.special_moves.include?(move)
        return false unless castle? (move)

      #handle en passante
      elsif piece.is_a?(Pawn) && piece.special_moves.include?(move)
        return false unless en_passante?(move) || pawn_attack_ok?(move)
      end

      return true
    end

    def perform_move(move)
      #we already know the move is valid
      #detect if there is a piece at the destination
      #remove the piece if so
      #move the piece that's at the origin to the destination

      startSquare = get_square(move[0])
      destSquare = get_square(move[1])

      #capture the piece, if there is one
      unless destSquare.empty?
        destSquare.remove_piece!
      end

      #move the piece from the start square to the finish square
      
      destSquare.add_piece!(startSquare.remove_piece!).moved = true
    end




    def change_player
      @active_player = other_player
    end

    def other_player
      return @active_player == players[0] ? players[1] : players[0]
    end

    #private

    def out_of_check? move

      #returns false if the move doesn't move you out of check, or if the move puts you in check
      
      start = move[0]
      destination = move[1]
      startSquare = get_square(start)
      destSquare = get_square(destination)

      destPieceBackup = destSquare.remove_piece!

      #pretend to do the move
      destSquare.add_piece!(startSquare.remove_piece!)

      check = check?

      #undo the move
      startSquare.add_piece!(destSquare.remove_piece!)

      destSquare.add_piece!(destPieceBackup)

      return !check
    end

    def square_attacked? square
      attackingPieces = pieces.filter {|piece| piece.color == other_player.color}
      return attackingPieces.any? {|piece|
        valid_move?([piece.position,square.id],other_player.color)
      }

    end

    def check?
      #if it's white's turn, check to see if white is in check.
      #look at all of black's pieces, and see if any of their valid moves end at the white king's position
      king = pieces.find{|piece| piece.is_a?(King) && piece.color == active_player.color}

      return square_attacked? get_square(king.position)
    end

    def path_clear? (path,color=active_player.color)
      #path is an array of squares
      #
      #only do the first check if the path is longer than 1 square
      unless path.length <= 1
        return false unless path[0...-1].all?{|square| square.empty?}
      end

      return false unless path.last.empty? || path.last.opposing_piece?(color)

      return true
    end

    def castle? move
      startSquare = get_square(move[0])
      destSquare = get_square(move[1])
      king = startSquare.piece

      return false unless king.is_a?(King)
      
      #king can't have moved yet
      return false if king.moved

      #determine queenside or kingside
      queenside = destSquare.minus(startSquare) == QUEENSIDE ? true : false

      rookSquare = queenside ? get_square(startSquare.plus([0,-4]))  : get_square(startSquare.plus([0,3]))
      
      rook = rookSquare.piece

      #rook can't have moved yet
      return false if rook.moved
      #king can't be in check
      return false if check?

      #king can't move through check
      if queenside
        return false if square_attacked?(get_square(startSquare.plus([0,-1])))
      else
        return false if square_attacked?(get_square(startSquare.plus([0,1])))
      end
      #king can't end in check
      return false if square_attacked?(destSquare)

      #can't be any pieces between king and rook
      return false unless squares_from_here(startSquare.id,rookSquare.minus(startSquare))[0...-1].all? {|square| square.empty?}

      return true
    end


    def castle move

      startSquare = get_square(move[0])
      destSquare = get_square(move[1])

      queenside = destSquare.minus(startSquare) == QUEENSIDE ? true : false

      rookStartSquare = queenside ? get_square(startSquare.plus([0,-4]))  : get_square(startSquare.plus([0,3]))
      rookDestSquare = queenside ? get_square(destSquare.plus([0,1])) : get_square(destSquare.plus([0,-1]))

      #move the king from the start square to the finish square
      
      destSquare.add_piece!(startSquare.remove_piece!).moved = true

      #move the rook from the rook start square to the rock finish square
      rookDestSquare.add_piece!(rookStartSquare.remove_piece!).moved = true
    end




    def en_passante? move
      #start piece must be pawn.  we already know that though.
      #piece at previous destination must be pawn
      
      #can't start the gam with en_passante
      return false if @previousMove.nil?

      startSquare = get_square(move[0])
      destSquare = get_square(move[1])

      return false unless startSquare.piece.is_a?(Pawn)

      prevStartSquare = get_square(previousMove[0])
      prevDestSquare = get_square(previousMove[1])
      
      return false unless prevDestSquare.piece.is_a?(Pawn)

      vector = SQUARE_HASH[move[1]].minus(SQUARE_HASH[move[0]])
      if active_player.color == WHITE && startSquare.rank == 5 && prevStartSquare.rank == 7 && prevDestSquare.rank == 5 && prevDestSquare.file == destSquare.file
        return true
      elsif startSquare.rank == 4 && prevStartSquare.rank == 2 && prevDestSquare.rank == 4 && prevDestSquare.file == destSquare.file
        return true
      else
        return false
      end
    end


    def pawn_attack_ok? move
      #determines if a pawn attack is happening
      startSquare = get_square(move[0])
      destSquare = get_square(move[1])
      return false unless startSquare.piece.is_a?(Pawn) && !destSquare.empty?
      return true
    end


    def en_passante move
      startSquare = get_square(move[0])
      destSquare = get_square(move[1])
      
      #have to find square to attack, since it's different from the destination square
      #if active player is white, attack square should be one rank below dest square
      attackSquare = active_player.color == WHITE ? get_square(destSquare.plus([-1,0])) : get_square(destSquare.plus([1,0]))
      
      attackSquare.remove_piece!

      #move the other pawn from the start square to the finish square
      destSquare.add_piece!(startSquare.remove_piece!).moved = true

    end

    def promote? piece
      #check to see if a pawn made it to the last rank
      return false
    end

    def promote piece
      #promote the pawn to a piece of the player's choice
    end
  end

  game = Game.create_game

  #uncomment next line to play
  game.play_game

end

























