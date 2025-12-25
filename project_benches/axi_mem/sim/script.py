#!/usr/bin/env python3
"""
Filename: script.py
Description:to run large numbers of tests on axi_mem module
Author: Jayesh Parab
"""
import csv
import subprocess
import random
import sys
import os
import argparse
import logging
import re

TESTS = ["test_top","direct_test_seq_wr"]

def parse_args():
    """Parse command-line arguments"""
    parser = argparse.ArgumentParser(
        description="Can be used to run multiple runs with randomized inputs or specific inputs"
    )
    parser.add_argument(
        "-t", "--test",
        dest="test",
        required=True,
        type=str,
        choices=["test_top","direct_test_seq_wr","random"],
        help="Provide a testname it can be test_top, direct_test_seq_wr or random(to randomly select one of the two)"
    )
    parser.add_argument(
        "-u", "--uvm_verbose",
        dest="uvm_verbose",
        type=str,
        default="UVM_NONE",
        help="This is for setting UVM verbosity, by default = %(default)s"
    )
    parser.add_argument(
        "-v", "--verbose",
        dest="verbose",
        action="store_true",
        default=False,
        help="This is for setting verbosity default = %(default)s"
    )
    parser.add_argument(
        "-r", "--random",
        dest="random",
        action="store_true",
        default=False,
        help="Provide randomized inputs by default is FALSE. If FALSE provide all the other arguments, or if TRUE provide those arguments you don't want to randomize"
    )
    parser.add_argument(
        "-l","--loop",
        dest="loop",
        required=True,
        type=int,
        default=1,
        help="Provide how many tests you want to run"
    )
    parser.add_argument(
        "--seeds",
        dest="seeds",
        nargs="+",
        type=int,
        default=[0],
        help="List of seeds (count must match --loop) default=%(default)s, if randomized then this is not nessary"
    )
    parser.add_argument(
        "--runs",
        dest="runs",
        nargs="+",
        type=int,
        default=[0],
        help="List of runs (count must match --loop) provide how many read-write pairs you want to perform default=%(default)s, if randomized then this is not nessary"
    )
    parser.add_argument(
        "--writes",
        dest="writes",
        nargs="+",
        type=int,
        default=[0],
        help="List of writes (count must match --loop) provide how many write you want to perform default=%(default)s, if randomized then this is not nessary"
    )
    parser.add_argument(
        "--reads",
        dest="reads",
        nargs="+",
        type=int,
        default=[0],
        help="List of reads (count must match --loop) provide how many reads you want to perform default=%(default)s, if randomized then this is not nessary"
    )
    return parser.parse_args()

def check_inputs(args):
    if not args.random:
        if args.loop != len(args.seeds):
            print(
            f"ERROR: --loop is {args.loop} but {len(args.seed)} seeds provided"
            )
            sys.exit(1)
        if args.test in ["test_top","random"] and args.loop != len(args.writes):
            print(
            f"ERROR: --loop is {args.loop} but {len(args.writes)} writes provided"
            )
            sys.exit(1)
        if args.test in ["test_top","random"] and args.loop != len(args.reads):
            print(
            f"ERROR: --loop is {args.loop} but {len(args.reads)} reads provided"
            )
            sys.exit(1)
        if args.test in ["direct_test_seq_wr","random"] and args.loop != len(args.runs):
            print(
            f"ERROR: --loop is {args.loop} but {len(args.runs)} runs provided"
            )
            sys.exit(1)

# def path_creator():
#     cwd = os.getcwd()

def command_runner(args):
    subprocess.run(['make','clean'],capture_output=True)
    for i in range(0,args.loop):
        if args.random:
            runs = random.randint(1,10000)
            writes= random.randint(1,10000)
            reads= random.randint(1,10000)
            seeds= random.randint(0,999999999)
        else:
            runs = args.runs
            writes = args.writes
            reads = args.reads
            seeds = args.seeds
        
        if args.test == "random":
            test = random.choice(TESTS)
        else:
            test = args.test

        cmd =  ['make',
                'cli',
                f'SV_SEED={seeds}',
                f'UVM_TEST={test}',
                f'READS={reads}',
                f'WRITES={writes}',
                f'RUNS={runs}',
                f'VERBOSITY={args.uvm_verbose}'
               ]
        logging.info(f"starting iteration: {i+1} Command: {" ".join(cmd)}")
        
        results = subprocess.run(cmd,
                                 check=True,
                                 capture_output=True,
                                 text=True
                                 )
        logging.debug(results.stdout)
        cmd = [
            'vcover',
            'report',
            '-details',
            '-output',
            f'ucdb/{test}_{seeds}.txt',
            f'{test}_{seeds}.ucdb'
        ]
        logging.info(f"Ending iteration: {i+1} Extracting coverage: {" ".join(cmd)}")
        results = subprocess.run(cmd,
                                 check=True,
                                 capture_output=True,
                                 text=True
                                 )
        logging.debug(results.stdout)

    cmd = [
        'make',
        'mergecover'
    ]
    logging.info(f"Merging coverage: {" ".join(cmd)}")
    results = subprocess.run(cmd,
                                check=True,
                                capture_output=True,
                                text=True
                                )
    logging.debug(results.stdout)
    
    cmd = [
        'vcover',
        'report',
        '-details',
        '-output',
        f'ucdb/final.txt',
        f'final.ucdb'
    ]
    logging.info(f"Extracting final coverage: {" ".join(cmd)}")
    results = subprocess.run(cmd,
                                check=True,
                                capture_output=True,
                                text=True
                                )
    logging.debug(results.stdout)


def setup_logging(verbose=False):
    """Setup logging configuration"""
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(
        level=level,
        format="%(asctime)s | %(levelname)s | %(message)s"
    )


def process_file():
    """Core logic of the script"""
    os.chdir("logs/")
    data_list = []
    input_path = os.getcwd()
    logs = [f for f in os.listdir(input_path) if os.path.isfile(os.path.join(input_path,f))]
    os.chdir("../ucdb/")
    input_path_ucdb = os.getcwd()
    os.chdir("../logs/")
    # ucdbs = [f for f in os.listdir(input_path) if os.path.isfile(os.path.join(input_path,f))]
    # if not os.path.exists(input_file):
        # logging.error(f"File not found: {input_file}")
        # sys.exit(1)
    for input_file in logs:
        data = {'Test' : "",
            'Seed' : 0,
            'Reads': 0,
            'Writes': 0,
            'Runs' : 0,
            'Total': 0,
            'Matches': 0,
            'Miss-Matches': 0,
            'UVM_INFO': 0,
            'UVM_WARNING': 0,
            'UVM_ERROR' : 0, 
            'UVM_FATAL': 0,
            'Coverage' : 0.0
            }
        
        logging.info(f"Processing file: {input_file}")

        with open(input_file, "r") as f:
            for line in f:
                line = line.strip()
                command=re.search(  r"-sv_seed\s+(\d+).*?"           # capture sv_seed
                                    r"\+UVM_TESTNAME=([\w\d_]+).*?"  # capture test name
                                    r"\+READS=(\d+).*?"              # capture READS
                                    r"\+WRITES=(\d+).*?"             # capture WRITES
                                    r"\+RUNS=(\d+)"                  # capture RUNS
                                ,line)
                result=re.search(r"# UVM_INFO.*?(Total|Matches|Miss-Matches):\s*(\d+)",line)
                result_2= re.search(r"#\s(UVM_INFO|UVM_WARNING|UVM_ERROR|UVM_FATAL)\s:\s*(\d+)",line)

                if command:
                    data["Seed"] = command.group(1)
                    data["Test"] = command.group(2)
                    data["Reads"] = command.group(3)
                    data["Writes"] = command.group(4)
                    data["Runs"] = command.group(5)

                if result:
                    if result.group(1) in data.keys():
                        data[result.group(1)] = result.group(2)
                if result_2:
                    if result_2.group(1) in data.keys():
                        data[result_2.group(1)] = result_2.group(2)

        with open(os.path.join(input_path_ucdb,f'{data["Test"]}_{data["Seed"]}.txt'),'r') as f:
            content = f.read()
            cov = re.findall(r'TOTAL\s+COVERGROUP\s+COVERAGE:\s*([\d.]+)%',content)
            if cov:
                data["Coverage"] = float(cov[0])
        data_list.append(data)

    data = {'Test' : "Total Coverage",
            'Seed' : "",
            'Reads': "",
            'Writes': "",
            'Runs' : "",
            'Total': "",
            'Matches': "",
            'Miss-Matches': "",
            'UVM_INFO': "",
            'UVM_WARNING': "",
            'UVM_ERROR' : "", 
            'UVM_FATAL': "",
            'Coverage' : 0.0
            }
    with open(os.path.join(input_path_ucdb,'final.txt'),'r') as f:
        content = f.read()
        cov = re.findall(r'TOTAL\s+COVERGROUP\s+COVERAGE:\s*([\d.]+)%',content)
        if cov:
            data["Coverage"] = float(cov[0])
    data_list.append(data)
    
    os.chdir("../")
    if not os.path.exists(os.path.join(os.getcwd(),'reports')):
        os.mkdir('reports')
    os.chdir('reports/')
    with open(os.path.join(os.getcwd(),'report.csv'),'w') as f:
        fieldnames = data_list[0].keys()
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in data_list:
            writer.writerow(row)

def main():
    args = parse_args()
    check_inputs(args)
    setup_logging(args.verbose)
    command_runner(args)
    process_file()


if __name__ == "__main__":
    main()
