process SCORE_PLOTS {

    label 'process_single'
    tag "All genes"
    container = 'ecoflowucl/chopgo:r-4.3.2_python-3.10_perl-5.38'
    publishDir "$params.outdir/Figures/Synteny_comparisons" , mode: "copy", pattern:"*-all.pdf"

    input:
    path(filec), stageAs: "filec"

    output:
    path("*-all.pdf")

    '''
    #!/usr/bin/Rscript
    Bee_inver_trans_prot <- read.delim("filec", stringsAsFactors=FALSE)

    # load library
    library("ggplot2")
    library("ggstar")
    # make a column for first species 
    Bee_inver_trans_prot$FirstSpecies <- gsub(x = Bee_inver_trans_prot$Comparison,
                                          pattern = "[A-z]*_[A-z]*",
                                          replacement = "")
    # make a column for second species
    Bee_inver_trans_prot$SecondSpecies <- gsub(x = Bee_inver_trans_prot$Comparison,
                                     pattern = "[A-z]*_[A-z]*",
                                     replacement = "")

    # obtain list of species
    species_vec <- unique(Bee_inver_trans_prot$FirstSpecies)

    # plot 1_CW: Trans_mimimum_count versus perc_identity
    ggplot(Bee_inver_trans_prot, aes(perc_identity, Trans_mimimum_count)) +  
    geom_star(aes(fill = FirstSpecies), size=2, starshape=19) +
    geom_star(aes(fill = SecondSpecies), size=2, starshape=20) +
    scale_shape_manual(values = c(1:length(species_vec)))+
    ggtitle("Percent identity and Translocation mimimum count") + 
    theme_classic() + 
    theme(legend.text = 
          element_text(size = 8),
        legend.title = element_text(size = 8)) 
    ggsave(filename = "translocationVSprot-all.pdf", width= 6, height=8 , device = "pdf")

    # plot 2: "Inversion_estimate" versus per_identity
    ggplot(Bee_inver_trans_prot, aes(perc_identity, Inversion_estimate)) +    
    geom_star(aes(fill = FirstSpecies), size=2, starshape=19) +
    geom_star(aes(fill = SecondSpecies), size=2, starshape=20) +
    scale_shape_manual(values = c(1:length(species_vec)))+
    ggtitle("Inversion estimate") + 
    theme_classic() + 
    theme(legend.text = 
          element_text(size = 8),
        legend.title = element_text(size = 8)) 
    ggsave(filename = "inversionVSprot-all.pdf", width= 6, height=8 , device = "pdf")

    # plot 3: Trans_mimimum_count versus Inversion_estimate
    ggplot(Bee_inver_trans_prot, aes(Trans_mimimum_count, Inversion_estimate)) +    
    geom_star(aes(fill = FirstSpecies), size=2, starshape=19) +
    geom_star(aes(fill = SecondSpecies), size=2, starshape=20) +
    scale_shape_manual(values = c(1:length(species_vec)))+
    ggtitle("Translocation mimimum count score vs Inversion estimate") + 
    theme_classic() + 
    theme(legend.text = 
          element_text(size = 8),
        legend.title = element_text(size = 8)) 
    ggsave(filename = "translocationVSinversion-all.pdf", width= 8, height=8 , device = "pdf")

    # plot 4: Inversion_junctions versus Inversion_estimate
    ggplot(Bee_inver_trans_prot, aes(perc_identity, Inversion_junctions)) +    
    geom_star(aes(fill = FirstSpecies), size=2, starshape=19) +
    geom_star(aes(fill = SecondSpecies), size=2, starshape=20) +
    scale_shape_manual(values = c(1:length(species_vec)))+
    ggtitle("Percent identity and Inversion junction count") + 
    theme_classic() + 
    theme(legend.text = 
          element_text(size = 8),
        legend.title = element_text(size = 8)) 
    ggsave(filename = "percentidentityVSinversion_junction-all.pdf", width= 8, height=8 , device = "pdf")

    # plot 5: Trans_mimimum_count versus Inversion_estimate
    ggplot(Bee_inver_trans_prot, aes(perc_identity, Translocation_junctions)) +    
    geom_star(aes(fill = FirstSpecies), size=2, starshape=19) +
    geom_star(aes(fill = SecondSpecies), size=2, starshape=20) +
    scale_shape_manual(values = c(1:length(species_vec)))+
    ggtitle("Percent identity and Translocation junction count") + 
    theme_classic() + 
    theme(legend.text = 
          element_text(size = 8),
        legend.title = element_text(size = 8)) 
    ggsave(filename = "percentidentityVStranslocation_junction-all.pdf", width= 8, height=8 , device = "pdf")    
    '''
}
