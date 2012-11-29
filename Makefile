EMSCRIPTEN_ROOT=$(shell python find_emscripten.py)
EMCC=$(EMSCRIPTEN_ROOT)/emcc
SRCDIR=graphviz-src
top_srcdir=../..

viz.js: $(SRCDIR) viz.c $(SRCDIR)/lib/cdt/libcdt-em.bc $(SRCDIR)/lib/common/libcommon-em.bc $(SRCDIR)/lib/gvc/libgvc-em.bc $(SRCDIR)/lib/pathplan/libpathplan-em.bc $(SRCDIR)/lib/sparse/libsparse-em.bc $(SRCDIR)/lib/pack/libpack-em.bc $(SRCDIR)/lib/graph/libgraph-em.bc $(SRCDIR)/lib/dotgen/libdotgen-em.bc $(SRCDIR)/lib/neatogen/libneatogen-em.bc $(SRCDIR)/plugin/core/libgvplugin_core-em.bc $(SRCDIR)/plugin/dot_layout/libgvplugin_dot_layout-em.bc $(SRCDIR)/plugin/neato_layout/libgvplugin_neato_layout-em.bc
	$(EMCC) -v -O2 -s EXPORTED_FUNCTIONS='["_vizRenderFromString"]' -o viz.js \
		-I$(SRCDIR)/lib/gvc \
		-I$(SRCDIR)/lib/common \
		-I$(SRCDIR)/lib/pathplan \
		-I$(SRCDIR)/lib/cdt \
		-I$(SRCDIR)/lib/graph \
		-I$(SRCDIR)/lib/sparse \
		-I$(SRCDIR)/lib/pack \
		-I$(SRCDIR)/lib/vpsc \
		-I$(SRCDIR)/lib/rbtree \
		-I$(SRCDIR)/lib/sfdpgen \
		viz.c $(SRCDIR)/lib/cdt/libcdt-em.bc $(SRCDIR)/lib/common/libcommon-em.bc $(SRCDIR)/lib/gvc/libgvc-em.bc $(SRCDIR)/lib/pathplan/libpathplan-em.bc $(SRCDIR)/lib/graph/libgraph-em.bc $(SRCDIR)/lib/sparse/libsparse-em.bc $(SRCDIR)/lib/pack/libpack-em.bc $(SRCDIR)/lib/vpsc/libvpsc-em.bc $(SRCDIR)/lib/rbtree/librbtree-em.bc $(SRCDIR)/lib/sfdpgen/libsfdpgen-em.bc $(SRCDIR)/lib/dotgen/libdotgen-em.bc $(SRCDIR)/lib/neatogen/libneatogen-em.bc $(SRCDIR)/plugin/dot_layout/libgvplugin_dot_layout-em.bc $(SRCDIR)/plugin/neato_layout/libgvplugin_neato_layout-em.bc $(SRCDIR)/plugin/core/libgvplugin_core-em.bc --pre-js pre.js --post-js post.js
	cp -f viz.js ~/scalableminds/oxalis/public/javascripts/libs

$(SRCDIR)/lib/cdt/libcdt-em.bc: 
	cd $(SRCDIR)/lib/cdt; $(EMCC) -o libcdt-em.bc \
		-I. \
		dtclose.c dtdisc.c dtextract.c dtflatten.c dthash.c dtlist.c dtmethod.c dtopen.c dtsize.c dtstrhash.c dttree.c dttreeset.c dtrestore.c dtview.c dtwalk.c

$(SRCDIR)/lib/common/libcommon-em.bc: 
	cd $(SRCDIR)/lib/common; $(EMCC) -o libcommon-em.bc \
		-I. \
		-I.. \
		-I../.. \
		-I../../.. \
		-I../gvc \
		-I../pathplan \
		-I../cdt \
		-I../graph \
		-I../xdot -DHAVE_CONFIG_H arrows.c emit.c utils.c labels.c memory.c fontmetrics.c geom.c globals.c htmllex.c htmlparse.c htmltable.c ns.c postproc.c routespl.c shapes.c splines.c colxlate.c psusershape.c pointset.c input.c xdot.c timing.c output.c

$(SRCDIR)/lib/gvc/libgvc-em.bc:
	cd $(SRCDIR)/lib/gvc; $(EMCC) -o libgvc-em.bc \
		-I. \
		-I.. \
		-I../.. \
		-I../../.. \
		-I../common \
		-I../pathplan \
		-I../cdt \
		-I../graph -DHAVE_CONFIG_H gvc.c gvconfig.c gvcontext.c gvdevice.c gvlayout.c gvevent.c gvjobs.c gvplugin.c gvrender.c gvusershape.c gvloadimage.c gvtextlayout.c

$(SRCDIR)/lib/pathplan/libpathplan-em.bc:
	cd $(SRCDIR)/lib/pathplan; $(EMCC) -o libpathplan-em.bc \
		-I. cvt.c inpoly.c route.c shortest.c solvers.c triang.c util.c visibility.c

$(SRCDIR)/lib/graph/libgraph-em.bc:
	cd $(SRCDIR)/lib/graph; $(EMCC) -o libgraph-em.bc \
		-I. \
		-I../cdt \
		-I../gvc \
		-I../common \
		-I../pathplan \
		agxbuf.c attribs.c edge.c graph.c graphio.c lexer.c node.c parser.c refstr.c trie.c

$(SRCDIR)/lib/sparse/libsparse-em.bc:
	cd $(SRCDIR)/lib/sparse; $(EMCC) -o libsparse-em.bc \
		-I.  \
		-I.. \
		-I../.. \
		-I../common \
		-I../pathplan \
		SparseMatrix.c general.c BinaryHeap.c IntStack.c

$(SRCDIR)/lib/pack/libpack-em.bc:
	cd $(SRCDIR)/lib/pack; $(EMCC) -o $(top_srcdir)/lib/pack/libpack-em.bc \
		-I$(top_srcdir) \
		-I$(top_srcdir)/lib/common \
		-I$(top_srcdir)/lib/gvc \
		-I$(top_srcdir)/lib/neatogen \
		-I$(top_srcdir)/lib/pathplan \
		-I$(top_srcdir)/lib/graph \
		-I$(top_srcdir)/lib/cdt \
		ccomps.c pack.c

$(SRCDIR)/lib/vpsc/libvpsc-em.bc:
	cd $(SRCDIR)/lib/vpsc; $(EMCC) -o $(top_srcdir)/lib/vpsc/libvpsc-em.bc \
		-I. \
		block.cpp blocks.cpp constraint.cpp generate-constraints.cpp \
		pairingheap/PairingHeap.cpp remove_rectangle_overlap.cpp \
		solve_VPSC.cpp csolve_VPSC.cpp variable.cpp

$(SRCDIR)/lib/rbtree/librbtree-em.bc:
	cd $(SRCDIR)/lib/rbtree; $(EMCC) -o $(top_srcdir)/lib/rbtree/librbtree-em.bc \
		-I$(top_srcdir) \
		-I$(top_srcdir)/.. \
		-DHAVE_CONFIG_H -DHAVE_STDINT_H misc.c red_black_tree.c stack.c

$(SRCDIR)/lib/sfdpgen/libsfdpgen-em.bc:
	cd $(SRCDIR)/lib/sfdpgen; $(EMCC) -o $(top_srcdir)/lib/sfdpgen/libsfdpgen-em.bc \
		-I. \
		-I$(top_srcdir) \
		-I$(top_srcdir)/lib/common \
		-I$(top_srcdir)/lib/gvc \
		-I$(top_srcdir)/lib/neatogen \
		-I$(top_srcdir)/lib/sparse \
		-I$(top_srcdir)/lib/rbtree \
		-I$(top_srcdir)/lib/pack \
		-I$(top_srcdir)/lib/pathplan \
		-I$(top_srcdir)/lib/graph \
		-I$(top_srcdir)/lib/cdt \
		sfdpinit.c spring_electrical.c \
		LinkedList.c sparse_solve.c post_process.c \
		stress_model.c uniform_stress.c \
		QuadTree.c Multilevel.c PriorityQueue.c

$(SRCDIR)/lib/dotgen/libdotgen-em.bc:
	cd $(SRCDIR)/lib/dotgen; $(EMCC) -o libdotgen-em.bc \
		-I. \
		-I.. \
		-I../.. \
		-I../../.. \
		-I../common \
		-I../gvc \
		-I../pathplan \
		-I../cdt \
		-I../graph \
		-DHAVE_CONFIG_H acyclic.c aspect.c class1.c class2.c cluster.c compound.c conc.c decomp.c dotinit.c dotsplines.c fastgr.c flat.c mincross.c position.c rank.c sameport.c

$(SRCDIR)/lib/neatogen/libneatogen-em.bc:
	cd $(SRCDIR)/lib/neatogen; $(EMCC) -o libneatogen-em.bc \
		-I. \
		-I.. \
		-I../.. \
		-I../../.. \
		-I../common \
		-I../pack \
		-I../vpsc \
		-I../gvc \
		-I../pathplan \
		-I../ortho \
		-I../rbtree \
		-I../sfdpgen \
		-I../sparse \
		-I../gd \
		-I../cdt \
		-I../graph \
		-DHAVE_CONFIG_H  adjust.c bfs.c call_tri.c circuit.c closest.c compute_hierarchy.c conjgrad.c constrained_majorization.c constrained_majorization_ipsep.c constraint.c delaunay.c dijkstra.c edges.c embed_graph.c geometry.c heap.c hedges.c info.c kkutils.c legal.c lu.c matinv.c matrix_ops.c memory.c mosek_quad_solve.c multispline.c neatoinit.c neatosplines.c opt_arrangement.c overlap.c pca.c poly.c printvis.c quad_prog_solve.c quad_prog_vpsc.c site.c smart_ini_x.c solve.c stress.c stuff.c voronoi.c 

$(SRCDIR)/plugin/core/libgvplugin_core-em.bc:
	cd $(SRCDIR)/plugin/core; $(EMCC) -o libgvplugin_core-em.bc \
		-I. \
		-I.. \
		-I../.. \
		-I../../.. \
		-I../../lib \
		-I../../lib/common \
		-I../../lib/gvc \
		-I../../lib/pathplan \
		-I../../lib/cdt \
		-I../../lib/graph \
		-DHAVE_CONFIG_H gvplugin_core.c gvrender_core_dot.c gvrender_core_fig.c gvrender_core_map.c gvrender_core_ps.c gvrender_core_svg.c gvrender_core_tk.c gvrender_core_vml.c gvloadimage_core.c

$(SRCDIR)/plugin/dot_layout/libgvplugin_dot_layout-em.bc:
	cd $(SRCDIR)/plugin/dot_layout; $(EMCC) -o libgvplugin_dot_layout-em.bc \
		-I. \
		-I.. \
		-I../.. \
		-I../../.. \
		-I../../lib \
		-I../../lib/common \
		-I../../lib/gvc \
		-I../../lib/pathplan \
		-I../../lib/cdt \
		-I../../lib/graph \
		-DHAVE_CONFIG_H gvplugin_dot_layout.c gvlayout_dot_layout.c

$(SRCDIR)/plugin/neato_layout/libgvplugin_neato_layout-em.bc:
	cd $(SRCDIR)/plugin/neato_layout; $(EMCC) -o libgvplugin_neato_layout-em.bc \
		-I. \
		-I.. \
		-I../.. \
		-I../../.. \
		-I../../lib \
		-I../../lib/common \
		-I../../lib/gvc \
		-I../../lib/pathplan \
		-I../../lib/cdt \
		-I../../lib/graph \
		-DHAVE_CONFIG_H gvplugin_neato_layout.c gvlayout_neato_layout.c

$(SRCDIR): | graphviz-src.tar.gz
	mkdir -p $(SRCDIR)
	tar xjf graphviz-src.tar.gz -C $(SRCDIR) --strip=1

graphviz-src.tar.gz:
	curl "http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.28.0.tar.gz" -o graphviz-src.tar.gz

clean:
	rm -f $(SRCDIR)/lib/*/*.bc
	rm -f $(SRCDIR)/plugin/*/*.bc
	rm -f viz.js

clobber: clean
	rm -rf $(SRCDIR)
	rm -f graphviz-src.tar.gz
