
params.iterations = 100
params.threads = 10

if( params.threads > 1 ) {
    randomization_chunks = (0..<params.threads)
    iterations_per_thread = params.iterations / params.threads
    iterations_per_thread = Math.ceil(iterations_per_thread).toInteger()
}
else {
    randomization_chunks = [ 0 ]
    iterations_per_thread = params.iterations
}


log.info """
        Total iter:       ${params.iterations}
        Threads:          ${params.threads}
        Iter per thread:  ${iterations_per_thread}
        """
        .stripIndent()

Channel
    .fromList( randomization_chunks )
    .view { "value: $it" }




process dummyproc {

    // publishDir "results", mode: 'copy'
    container "alpine:latest"
    cpus 1
    
    input:
      val RND

    output:
      path "res.txt", emit: res

    script:
    """
    echo ${RND} > res.txt
    """
}



workflow {

    // Channel of randomization chunks
    rnd_ch = Channel.fromList( randomization_chunks )

    // Perform Biodiverse randomizations
    dummyproc(rnd_ch)

}

