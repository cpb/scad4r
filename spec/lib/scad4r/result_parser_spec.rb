require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'scad4r/result_parser'

require 'ostruct'

module Scad4r
  describe ResultParser do
    subject { OpenStruct.new(described_class.new.parse(scad_result)) }

    context "with errors" do
      let(:scad_result) { <<-END
Parser error in line 47: syntax error

  END
  }
      its(:error) { should eql("syntax error line 47") }
    end

    context "with warnings" do
      let(:scad_result) { <<-END
Compiling library '/Users/caleb/Things/jhead_nozzel/nozzel_mounting.scad'.
  compiled module: 0x1044198b0
  /Users/caleb/Things/jhead_nozzel/nozzel_mounting.scad: 0x1044198b0
Compiling library '/Users/caleb/Things/jhead_nozzel/jhead.scad'.
  compiled module: 0x104413da0
Compiling library '/Users/caleb/Things/jhead_nozzel/screws.scad'.
  compiled module: 0x101ac6020
  /Users/caleb/Things/jhead_nozzel/screws.scad: 0x101ac6020
  /Users/caleb/Things/jhead_nozzel/jhead.scad: 0x104413da0
ECHO: [-20, -5, -4.39, 0]
WARNING: Ignoring unknown module 'foobar'.
END
      }

      its(:warnings) { should include("Ignoring unknown module 'foobar'.")}
      its(:error) { should be_nil }
    end

    context "with echo" do
      let(:scad_result) { <<-END
Compiling library '/Users/caleb/Things/jhead_nozzel/nozzel_mounting.scad'.
  compiled module: 0x1044198b0
  /Users/caleb/Things/jhead_nozzel/nozzel_mounting.scad: 0x1044198b0
Compiling library '/Users/caleb/Things/jhead_nozzel/jhead.scad'.
  compiled module: 0x104413da0
Compiling library '/Users/caleb/Things/jhead_nozzel/screws.scad'.
  compiled module: 0x101ac6020
  /Users/caleb/Things/jhead_nozzel/screws.scad: 0x101ac6020
  /Users/caleb/Things/jhead_nozzel/jhead.scad: 0x104413da0
ECHO: [-20, -5, -4.39, 0]
WARNING: Ignoring unknown module 'foobar'.
END
      }

      its(:echos) { should include("[-20, -5, -4.39, 0]")}
      its(:error) { should be_nil }
    end

    context "with echo and warnings" do
      let(:scad_result) { <<-END
Compiling library '/Users/caleb/Things/jhead_nozzel/nozzel_mounting.scad'.
  compiled module: 0x1044198b0
  /Users/caleb/Things/jhead_nozzel/nozzel_mounting.scad: 0x1044198b0
Compiling library '/Users/caleb/Things/jhead_nozzel/jhead.scad'.
  compiled module: 0x104413da0
Compiling library '/Users/caleb/Things/jhead_nozzel/screws.scad'.
  compiled module: 0x101ac6020
  /Users/caleb/Things/jhead_nozzel/screws.scad: 0x101ac6020
  /Users/caleb/Things/jhead_nozzel/jhead.scad: 0x104413da0
ECHO: [-20, -5, -4.39, 0]
WARNING: Ignoring unknown module 'foobar'.
END
      }

      its(:echos) { should include("[-20, -5, -4.39, 0]")}
      its(:warnings) { should include("Ignoring unknown module 'foobar'.")}
    end

    context "with many echo and warnings" do
      let(:scad_result) { <<-END
Compiling library '/Users/caleb/Things/jhead_nozzel/nozzel_mounting.scad'.
  compiled module: 0x101ada2a0
  /Users/caleb/Things/jhead_nozzel/nozzel_mounting.scad: 0x101ada2a0
Compiling library '/Users/caleb/Things/jhead_nozzel/jhead.scad'.
  compiled module: 0x101a7e670
Compiling library '/Users/caleb/Things/jhead_nozzel/screws.scad'.
  compiled module: 0x10791ddd0
  /Users/caleb/Things/jhead_nozzel/screws.scad: 0x10791ddd0
  /Users/caleb/Things/jhead_nozzel/jhead.scad: 0x101a7e670
ECHO: [-20, -5, -4.39, 0]
WARNING: Ignoring unknown module 'foobar'.
WARNING: Ignoring unknown module 'foobar'.
ECHO: [-20, -5, -4.39, 0]
ECHO: [-20, -5, -4.39, 0]
WARNING: Ignoring unknown module 'foobar'.
WARNING: Ignoring unknown module 'foobar'.
END
      }

      its(:echos) { should have(3).items }
      its(:warnings) { should have(4).items }
    end

    context "with timings" do

      let(:scad_result) { <<-END
CGAL Cache insert: import(file=\"../Huxley/Print-Huxley/Indi (1728992 bytes)\nCGAL Cache insert: multmatrix([[1,0,0,20],[0,1,0,0],[0,0,1, (1728992 bytes)\nCGAL Cache insert: group(){multmatrix([[1,0,0,20],[0,1,0,0] (1728992 bytes)\nCGAL Cache insert: group(){group(){multmatrix([[1,0,0,20],[ (1728992 bytes)\nCGAL Cache insert: cylinder($fn=24,$fa=12,$fs=2,h=5,r1=1.65 (62712 bytes)\nCGAL Cache hit: cylinder($fn=24,$fa=12,$fs=2,h=5,r1=1.65 (62712 bytes)\nCGAL Cache hit: cylinder($fn=24,$fa=12,$fs=2,h=5,r1=1.65 (62712 bytes)\nCGAL Cache hit: cylinder($fn=24,$fa=12,$fs=2,h=5,r1=1.65 (62712 bytes)\nCGAL Cache insert: multmatrix([[1,0,0,7.5],[0,1,0,2.9],[0,0 (62712 bytes)\nCGAL Cache insert: multmatrix([[1,0,0,32.5],[0,1,0,2.9],[0, (62712 bytes)\nCGAL Cache insert: multmatrix([[1,0,0,32.5],[0,1,0,25.9],[0 (62712 bytes)\nCGAL Cache insert: multmatrix([[1,0,0,7.5],[0,1,0,25.9],[0, (62712 bytes)\nCGAL Cache insert: cube(size=[3,3,5],center=false); (10872 bytes)\nCGAL Cache insert: multmatrix([[0.707107,-0.707107,0,0],[0. (10872 bytes)\nCGAL Cache hit: multmatrix([[0.707107,-0.707107,0,0],[0. (10872 bytes)\nCGAL Cache insert: multmatrix([[1,0,0,-1.06066],[0,1,0,-2.1 (10872 bytes)\nCGAL Cache insert: multmatrix([[1,0,0,41.0607],[0,1,0,-2.12 (10872 bytes)\nCGAL Cache insert: cube(size=[5.83095,5.83095,5],center=fal (10872 bytes)\nCGAL Cache insert: multmatrix([[0.857493,-0.514496,0,0],[0. (10872 bytes)\nCGAL Cache hit: cube(size=[5.83095,5.83095,5],center=fal (10872 bytes)\nCGAL Cache insert: multmatrix([[0.514496,-0.857493,0,0],[0. (10872 bytes)\nCGAL Cache insert: cube(size=[40,28.8,5],center=false); (10872 bytes)\nCGAL Cache insert: group(){multmatrix([[1,0,0,7.5],[0,1,0,2 (250560 bytes)\nCGAL Cache insert: group(){multmatrix([[1,0,0,-1.06066],[0, (21648 bytes)\nCGAL Cache insert: multmatrix([[1,0,0,0],[0,1,0,25.8],[0,0, (10872 bytes)\nCGAL Cache insert: multmatrix([[1,0,0,40],[0,1,0,25.8],[0,0 (10872 bytes)\nCGAL Cache insert: difference(){cube(size=[40,28.8,5],cente (273048 bytes)\nCGAL Cache hit: group(){group(){multmatrix([[1,0,0,20],[ (1728992 bytes)\nCGAL Cache hit: difference(){cube(size=[40,28.8,5],cente (273048 bytes)\nCGAL Cache insert: group(){difference(){cube(size=[40,28.8, (273048 bytes)\nCGAL Cache insert: difference(){group(){group(){multmatrix( (1190904 bytes)\nCGAL Cache insert: multmatrix([[1,0,0,-60],[0,1,0,0],[0,0,1 (1728992 bytes)\nCGAL Cache insert: multmatrix([[1,0,0,60],[0,1,0,0],[0,0,1, (1190904 bytes)\nCGAL Cache insert: group(){multmatrix([[1,0,0,-60],[0,1,0,0 (3192752 bytes)\nObject isn't a valid 2-manifold! Modify your design.\n       52.44 real        48.14 user         0.34 sys
END
      }

      its(:real) { should eql("52.44") }
      its(:user) { should eql("48.14") }
      its(:sys) { should eql("0.34") }
    end
  end
end
