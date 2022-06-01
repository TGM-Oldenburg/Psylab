# Makefile for PSYLAB
#
# Author:  Martin Hansen <martin.hansen AT fh-oldenburg.de>
# Date:    24 Oct 2004
# Updated: 30 Nov 2005
# Updated: 06 Jan 2006
# Updated: 10 Mar 2006
# Updated: 15 May 2006
# Updated: 01 Nov 2006
# Updated: 20 Jun 2007
# Updated: 24 Feb 2009
# Updated: 30 Mar 2009
#


VERSION = 2.10

DIR = psylab-$(VERSION)
DISTBASE = $(DIR)
# archive file prefix
AFILE = $(DIR)

# these files are the central part of the psylab distribution
PSYFILES = DISTRIBUTION INSTALLATION \
     NO-WARRANTY PSYLAB-LICENSE PSYLAB-ABOUT GNU-GPL \
     mpsy_init.m mpsy_init_run.m mpsy_check.m mpsy_check_psydat_file.m \
     mpsy_afc_main.m mpsy_afc_present.m mpsy_nafc.m mpsy_nafc_singleref.m \
     mpsy_*intrlv*.m     mpsy_afc_conststim_main.m \
     mpsy_match_main.m mpsy_match_present.m mpsy_match.m \
     mpsy_get_useranswer.m \
     mpsy_adapt_*up_*down.m mpsy_adapt_*wud.m \
     mpsy_*afc_gui.m mpsy_*auc_gui.m mpsy_up_down_gui.m \
     mpsy_info.m mpsy_visual_interval_*.m \
     mpsy_msound_present.m \
     msound.dll msound.mexw32 msound.mexw64 msound*.mexglx msound.mexa64 msound.mexmaci64 \
     mpsy_proto_adapt.m mpsy_proto_conststim.m mpsy_proto_debuginfo.m \
     mpsy_plot_feedback.m  mpsy_plot_thresholds.m mpsy_plot_psycfunc.m mpsy_plot_data.m \
     mpsy_replot_run.m read_psydat.m read_psydat_v2.m  mpsy_split_lines_to_toks.m \
     display_psydat.m display_psydat_v2.m display_psydat_raw_v2.m \
     psydat_helper.m psydat_helper.fig \
     psylab_header.m mpsy_version.m \
     mpsy_querysplash.m PSYLAB_SPLASH \
     mpsy_maxreversal_askagain.m  mpsy_maxreversal_check.m

# these directories are formed (using mkdir) as part of the psylab distribution
# DISTDIRS = doc examples contrib
DISTDIRS = doc examples contrib contrib/huggins_pitch contrib/melody_recognition

# these files are part of the psylab documentation
DOCFILES = doc/Makefile doc/psylab-doc-v1.tex \
           doc/psylab-doc.tex doc/psylab-doc.dvi doc/psylab-doc.pdf doc/*.eps 

# these files are additional helpful scripts, but psylab works without them
SCRIPTS = rms.m gensin.m hanwin.m fft_rect_filt.m

# these files contain example experiments
EXAMPLES = examples/abs_threshold*.m \
           examples/jnd_frequency*.m  \
           examples/jnd_intensity*.m  \
           examples/sam_*.m \
           examples/match_freq_binaural_intrlv*.m \
           examples/tone_in_broadbandnoise*.m \
           examples/*instruction*.txt  \
           contrib/*
           #contrib/huggins_pitch/*  contrib/melody_recognition/*


### EXAMPLES = examples/*phase*.m examples/frozen_noise1.wav

# these files are needed for simulations (Dau's optimal detector model)
# which replace listening experiments with subjects.
# these files are **not** part of psylab
SIMUFILES = mpsy_simu_main.m mpsy_simulation.m mpsy_simu_main_mult_reps_template.m \
            mpsy_internal_repr.m mpsy_template.m mpsy_optdet.m

# some additional programs or scripts, not public part of psylab
PROGS = check_messphase.m mpsy_simulate_*_answer_*.m test_adaptive_rule.m \
        mpsy_proto_v1.m mpsy_simu_main0.m

# some additional text files, not public
TEXTS = Makefile ChangeLog TODO todolist-versionchange.txt 

# these additional files and subdirs are not public part of psylab
EXTRAFILES = exp2 simu tests \
             psydat_helper*


# these files go public in the bare psylab distribution
BAREFILES = $(PSYFILES) $(DOCFILES)

# these files go public in the normal psylab distribution
DISTFILES = $(PSYFILES) $(DOCFILES) $(SCRIPTS) $(EXAMPLES)

# these files contain the simulaton as an add-on
SIMUDIST = $(DISTFILES) $(SIMUFILES)

# these files contain only the extra simulation files
SIMUEXTRA = $(SIMUFILES)

# everything of psylab, usually not public
EVTHING = $(DISTFILES) $(SIMUFILES) $(PROGS) $(TEXTS) $(DISTDIRS) $(EXTRAFILES) 

distribution: docu dist_base
	# new step since version 2.6:
	cp mpsy_maxreversal_askagain.m mpsy_maxreversal_check.m ; \
	rm mpsy_maxreversal_dontask.m ; \
	set -- $(DISTFILES) ; \
	for sdir do \
	  cp -p $$sdir $(DIR)/$$sdir ; \
	  done ; \
	tar cvfz $(AFILE)-dist.tar.gz  $(DIR) ; \
	if [ -e $(AFILE)-dist.zip ]; \
	then \
	  rm $(AFILE)-dist.zip ; \
	fi ; \
	zip -r $(AFILE)-dist.zip $(DIR)/*

docu: 
	cd doc; $(MAKE) docu;  cd ..

dist_base:
	if [ ! -d $(DISTBASE) ]; \
	then \
	  mkdir $(DISTBASE); \
	fi ; \
	set -- $(DISTDIRS) ; \
	for sdir do \
	  if [ ! -d $(DISTBASE)/$$sdir ]; \
	  then \
	    mkdir $(DISTBASE)/$$sdir ; \
	  fi ; \
	done

dist: docu 
	tar cvfz $(AFILE)-dist.tar.gz  $(DISTFILES) 

dist-bare: 
	tar cvfz $(AFILE)-bare.tar.gz $(BAREFILES)

zip: docu
	zip $(AFILE)-dist.zip   $(DISTFILES)

zip-bare:
	zip $(AFILE)-bare.zip   $(BAREFILES)

simu-extra:
	zip $(AFILE)-simu-extras.zip   $(SIMUFILES)

everything:
	tar cvfz $(AFILE)-evthing.tar.gz  $(EVTHING)



# End of Makefile
