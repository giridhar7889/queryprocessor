
# Query Processor
================

## Overview
-----------

The Query Processor is a high-performance search engine system designed to efficiently index a large collection of documents and process user queries.

## System Architecture
---------------------

* **Index Generator**: Responsible for creating an inverted index from a corpus of documents using an I/O-efficient merge-sort algorithm.
* **Lexicon**: A mapping of terms to their start index, end index, and document frequency.
* **URL Table**: A mapping of document IDs to their corresponding URLs and metadata.
* **Query Processor**: Processes user queries using the BM25 ranking function and document-at-a-time query processing algorithm.

## Input Data File
-----------------

* **Documents**: The input data file contains a collection of documents in gzip-compressed format.
* **File Name**: `documents.gz`
* **Format**: Each document is represented as a JSON object containing the document ID, URL, and text content.

## Internal Working of Query Processing Algorithm
---------------------------------------------

1. **Query Tokenization**: The user query is tokenized into individual terms.
2. **Lexicon Lookup**: Each term is looked up in the lexicon to retrieve its start index, end index, and document frequency.
3. **Inverted List Retrieval**: The inverted list for each term is retrieved from the inverted index.
4. **Document-at-a-Time Query Processing**: The documents are processed one at a time, and the BM25 score is computed for each document.
5. **Ranking**: The documents are ranked based on their BM25 scores.

## Results and Performance
-------------------------

* **Top 10 Results**: The top 10 results are displayed, along with their corresponding BM25 scores.
* **Query Processing Time**: The average query processing time is 50-100 milliseconds.
* **Indexing Time**: The indexing time for 3.2 million pages is approximately 83 minutes.
* **Index Size**: The compressed index size is approximately 1.5 GB.

## Time Complexity
-----------------

* **Index Generation**: O(n log n) due to the use of I/O-efficient merge-sort algorithm.
* **Query Processing**: O(m log m) due to the use of document-at-a-time query processing algorithm, where m is the number of documents.

## Technical Requirements
----------------------

* Java 8+
* 8 GB RAM+
* 1.5 GB disk space+

## Note
----

This project is designed to handle a substantial volume of data efficiently. The performance metrics may vary depending on the size and complexity of the input dataset.
