
params.input = "~"
params.iterations = 100
params.threads = 2

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
    container "ubuntu:20.04"
    cpus 1
    
    input:
      val RND

    output:
      path "res.txt", emit: res

    script:
    """

    echo "------- LaunchDir:  ${workflow.launchDir}"  > res.txt
    echo "------- WorkDir:    ${workflow.workDir}"    >> res.txt
    echo "------- ProjectDir: ${workflow.projectDir}" >> res.txt
    
    echo "------- /mnt content:"  >> res.txt
    ls -la /mnt >> res.txt

    echo "------- PWD: \$(pwd)" >> res.txt
    echo "PWD content: " >> res.txt
    ls -la >> res.txt
    
    echo "------- Input dir: ${params.input}" >> res.txt
    echo "Input dir content: " >> res.txt
    ls -la ${params.input} >> res.txt

    """
}


workflow {

    // Channel of randomization chunks
    rnd_ch = Channel.fromList( randomization_chunks )

    // Perform Biodiverse randomizations
    dummyproc(rnd_ch)

}

