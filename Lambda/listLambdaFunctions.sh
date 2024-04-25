#!/bin/bash

aws lambda list-functions --query 'Functions[*].FunctionName' 
