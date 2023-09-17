#!/bin/bash
kill $(cat backend-pid)
kill $(cat frontend-pid)