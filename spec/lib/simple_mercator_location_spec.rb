require "spec_helper"

describe SimpleMercatorLocation do

  describe "accessors" do

    let(:loc) { SimpleMercatorLocation.new }

    attrs = [:lat_deg, :lon_deg, :zoom]

    attrs.each do |attr|
      it "should have getter and setter for #{attr}" do
        loc.should respond_to("#{attr}".to_sym)
        loc.should respond_to("#{attr}=".to_sym)
        loc.send("#{attr}=".to_sym, "asd")
        loc.send("#{attr}".to_sym).should eql "asd"
      end
    end
  end


  describe "#initialize" do
    context "without args" do

      let(:loc) { SimpleMercatorLocation.new }

      it "returns a location object" do
        loc.should be_an_instance_of(SimpleMercatorLocation)
      end
    end


    context "given a hash with lat, lon and zoom" do
      let(:loc) { SimpleMercatorLocation.new(lat: 1, lon: 2, zoom: 12) }

      it "returns a location object" do
        loc.should be_an_instance_of(SimpleMercatorLocation)
      end

      it "return a location object with lat and lon set" do
        loc.lat_deg.should eql 1
        loc.lon_deg.should eql 2
        loc.zoom.should eql 12
      end
    end
  end


  describe "#zoom_at" do
    let(:loc) { SimpleMercatorLocation.new }
    it "sets the zoom scale and returns self" do
      loc.zoom_at(15).should eql loc
      loc.zoom_at(15).zoom.should eql 15
    end
  end

  describe "to_m" do
    context "given no args (so using lat = 0 and lon = 0)" do
      let(:loc) { SimpleMercatorLocation.new }
      it "should return origin" do
        loc.to_m.should eql  [0.0,0.0]
      end
    end

    context "given a location" do
      places =
        [
          { lat: 48.16608541901253, lon: 11.6455078125, mx: 1296371.99971659, my: 6134530.14205511 },
          { lat: 48.10743118848038, lon: 11.42578125,   mx: 1271912.15066533, my: 6124746.20243460 },
          { lat: 48.22467264956519, lon: 12.12890625,   mx: 1350183.66762935, my: 6144314.08167561 },
          { lat: 0,                 lon: 0,             mx: 0.0,              my: 0.0 },
        ]
      places.each do |place|
        it "calculates the mercator projection of (lat: #{place[:lat]}, lon: #{place[:lon]}) to (meters x: #{place[:mx]}, meters y: #{place[:my]})" do
          meters = SimpleMercatorLocation.new(lon: place[:lon], lat: place[:lat]).to_m
          meters.map!{|m| m.round(8) }.should eql([place[:mx], place[:my]])
        end
      end
    end
  end

  describe "to_w" do
    places =
        [
          { lat: 41.850033, lon: -87.65005229999997, wx: 65.67107392000001, wy: 95.1748950436046 },
          #{ lat: 48.10743118848038, lon: 11.42578125,   wx: 1271912.15066533, wy: 6124746.20243460 },
          #{ lat: 48.22467264956519, lon: 12.12890625,   wx: 1350183.66762935, wy: 6144314.08167561 },
          #{ lat: 0,                 lon: 0,             wx: 0.0,              wy: 0.0 },
        ]
      places.each do |place|
        it "calculates the mercator projection of (lat: #{place[:lat]}, lon: #{place[:lon]}) to (world coordinate x: #{place[:wx]}, world coordinate y: #{place[:wy]})" do
          SimpleMercatorLocation.new(lon: place[:lon], lat: place[:lat]).to_w.should eql([place[:wx], place[:wy]])
        end
      end


  end


  describe "to_px" do
    places =
      [
        { zoom: 11, lat: 49.38237278700955, lon: 8.61328125, px: 274688,  py: 179200  },
        { zoom: 14, lat: 49.38237278700955, lon: 8.61328125, px: 2197504, py: 1433600 },
      ]

    places.each do |place|
      it "calculates the pixels of (lat: #{place[:lat]}, lon: #{place[:lon]}) to (px: #{place[:px]}, py: #{place[:py]})" do
        SimpleMercatorLocation.new(lon: place[:lon], lat: place[:lat], zoom: place[:zoom]).to_px.should eql([place[:px], place[:py]])
      end
    end
  end


  describe "to_tile" do
    places =
      [
        { zoom: 11, lat: 49.412758, lon: 8.671938,   tx: 1073,  ty: 699 },
        { zoom: 11, lat: 40.689359, lon: -74.045197, tx: 602,   ty: 770  },
        { zoom: 15, lat: 40.689359, lon: -74.045197, tx: 9644,  ty: 12322 },
      ]

    places.each do |place|
      it "calculates the tile of (lat: #{place[:lat]}, lon: #{place[:lon]}) to (tile x: #{place[:tx]}, tile y: #{place[:ty]})" do
        SimpleMercatorLocation.new(lon: place[:lon], lat: place[:lat], zoom: place[:zoom]).to_tile.should eql([place[:tx], place[:ty]])
      end
    end
  end

end
