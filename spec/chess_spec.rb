require "./lib/chess.rb"

RSpec.describe("Chess")  do
  #initial positions correct?
  describe('#Game.initialize') do
    it "positions initial pieces correctly" do
      game = Game.new
      expect(game.get_square(:a1).piece.class).to eql(Rook)
      expect(game.get_square(:b1).piece.class).to eql(Knight)
      expect(game.get_square(:c1).piece.class).to eql(Bishop)
      expect(game.get_square(:d1).piece.class).to eql(Queen)
      expect(game.get_square(:e1).piece.class).to eql(King)
      expect(game.get_square(:f1).piece.class).to eql(Bishop)
      expect(game.get_square(:g1).piece.class).to eql(Knight)
      expect(game.get_square(:h1).piece.class).to eql(Rook)
      expect(game.get_square(:a2).piece.class).to eql(Pawn)
      expect(game.get_square(:b2).piece.class).to eql(Pawn)
      expect(game.get_square(:c2).piece.class).to eql(Pawn)
      expect(game.get_square(:d2).piece.class).to eql(Pawn)
      expect(game.get_square(:e2).piece.class).to eql(Pawn)
      expect(game.get_square(:f2).piece.class).to eql(Pawn)
      expect(game.get_square(:g2).piece.class).to eql(Pawn)
      expect(game.get_square(:h2).piece.class).to eql(Pawn)
      expect(game.get_square(:a7).piece.class).to eql(Pawn)
      expect(game.get_square(:b7).piece.class).to eql(Pawn)
      expect(game.get_square(:c7).piece.class).to eql(Pawn)
      expect(game.get_square(:d7).piece.class).to eql(Pawn)
      expect(game.get_square(:e7).piece.class).to eql(Pawn)
      expect(game.get_square(:f7).piece.class).to eql(Pawn)
      expect(game.get_square(:g7).piece.class).to eql(Pawn)
      expect(game.get_square(:h7).piece.class).to eql(Pawn)
      expect(game.get_square(:a8).piece.class).to eql(Rook)
      expect(game.get_square(:b8).piece.class).to eql(Knight)
      expect(game.get_square(:c8).piece.class).to eql(Bishop)
      expect(game.get_square(:d8).piece.class).to eql(Queen)
      expect(game.get_square(:e8).piece.class).to eql(King)
      expect(game.get_square(:f8).piece.class).to eql(Bishop)
      expect(game.get_square(:g8).piece.class).to eql(Knight)
      expect(game.get_square(:h8).piece.class).to eql(Rook)
      expect(game.get_square(:a1).piece.color).to eql(WHITE)
      expect(game.get_square(:b1).piece.color).to eql(WHITE)
      expect(game.get_square(:c1).piece.color).to eql(WHITE)
      expect(game.get_square(:d1).piece.color).to eql(WHITE)
      expect(game.get_square(:e1).piece.color).to eql(WHITE)
      expect(game.get_square(:f1).piece.color).to eql(WHITE)
      expect(game.get_square(:g1).piece.color).to eql(WHITE)
      expect(game.get_square(:h1).piece.color).to eql(WHITE)
      expect(game.get_square(:a2).piece.color).to eql(WHITE)
      expect(game.get_square(:b2).piece.color).to eql(WHITE)
      expect(game.get_square(:c2).piece.color).to eql(WHITE)
      expect(game.get_square(:d2).piece.color).to eql(WHITE)
      expect(game.get_square(:e2).piece.color).to eql(WHITE)
      expect(game.get_square(:f2).piece.color).to eql(WHITE)
      expect(game.get_square(:g2).piece.color).to eql(WHITE)
      expect(game.get_square(:h2).piece.color).to eql(WHITE)
      expect(game.get_square(:a7).piece.color).to eql(BLACK)
      expect(game.get_square(:b7).piece.color).to eql(BLACK)
      expect(game.get_square(:c7).piece.color).to eql(BLACK)
      expect(game.get_square(:d7).piece.color).to eql(BLACK)
      expect(game.get_square(:e7).piece.color).to eql(BLACK)
      expect(game.get_square(:f7).piece.color).to eql(BLACK)
      expect(game.get_square(:g7).piece.color).to eql(BLACK)
      expect(game.get_square(:h7).piece.color).to eql(BLACK)
      expect(game.get_square(:a8).piece.color).to eql(BLACK)
      expect(game.get_square(:b8).piece.color).to eql(BLACK)
      expect(game.get_square(:c8).piece.color).to eql(BLACK)
      expect(game.get_square(:d8).piece.color).to eql(BLACK)
      expect(game.get_square(:e8).piece.color).to eql(BLACK)
      expect(game.get_square(:f8).piece.color).to eql(BLACK)
      expect(game.get_square(:g8).piece.color).to eql(BLACK)
      expect(game.get_square(:h8).piece.color).to eql(BLACK)
    end
  end
  describe('#valid_move') do
    it ("allows valid Pawn moves") do
      game = Game.new
      move = [:a2,:a4]
      expect(game.valid_move?(move)).to eql(true)
    end

    it ("allows valid Pawn moves") do
      game = Game.new
      move = [:a2,:a3]
      expect(game.valid_move?(move)).to eql(true)
    end

    it("allows valid Knight moves") do
      game = Game.new
      move = [:b1,:c3]
      expect(game.valid_move?(move)).to eql(true)
    end

  end
end