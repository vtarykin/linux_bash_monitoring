#!/bin/bash

start_timer() {

	start_time=$(date +%s%N)  #$(date +%s%N | cut -b1-13)  #$(date +%s)

}


stop_timer() {

	end_time=$(date +%s%N) #$(date +%s)
}

get_time() {

	execution_time=$((end_time - start_time))
	elapsed_seconds=$(echo "scale=1; $execution_time / 1000000000" | bc)

}
