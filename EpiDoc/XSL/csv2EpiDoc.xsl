<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
	<xsl:output indent="yes" method="xml" encoding="UTF-8" name="xml"/>
	<xsl:key name="source" match="row[@n = 'title']/cell[position() &lt; 34]" use="@n"/>
	<xsl:strip-space elements="*"/>
	<xsl:variable name="folder">
		<xsl:text>xml_</xsl:text>
		<xsl:value-of select="format-dateTime(current-dateTime(), '[Y0001][M01][D01]_[H01][m01]')"/>
	</xsl:variable>
	<xsl:template match="/">
		<xsl:for-each select="//table/row[not(@title)]">
			<!-- identifier -->
			<xsl:variable name="prefid" select="'K_'"/>
			<xsl:variable name="id" select="cell[@n = 1]"/>
			<xsl:variable name="extension">
				<xsl:if test="not(cell[@n = 2] = '-')">
					<xsl:text>_</xsl:text>
					<xsl:value-of select="cell[@n = 2]"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="indice">
				<xsl:if test="not(cell[@n = 3] = '-')">
					<xsl:text>_</xsl:text>
					<xsl:value-of select="cell[@n = 3]"/>
				</xsl:if>
			</xsl:variable>
			<!-- to avoid duplicate ids -->
			<xsl:variable name="pos">
				<xsl:text>_</xsl:text>
				<xsl:number/>
			</xsl:variable>
			<!-- to avoid duplicate ids, the language is added -->
			<xsl:variable name="cell13" select="cell[@n = 13]"/>
			<xsl:variable name="langue" select="replace($cell13, '\?', 'incertain')"/>
			<xsl:variable name="langue" select="replace($langue, '\s', '-')"/>
			<xsl:variable name="langue2">
				<xsl:for-each select="tokenize(normalize-space($langue), ';')">
					<xsl:text>_</xsl:text>
					<xsl:value-of select="."/>
				</xsl:for-each>
			</xsl:variable>
			<!-- reading identifier -->
			<xsl:variable name="id_read">
				<xsl:value-of select="concat('K. ', cell[@n = 1], $extension, $indice, $langue2, $pos)"/>
			</xsl:variable>
			<!-- repositories -->
			<xsl:variable name="situationActuelle" select="cell[@n = '8']"/>
			<xsl:variable name="repo">
				<xsl:value-of select="''"/>
				<xsl:choose>
					<xsl:when test="contains(lower-case($situationActuelle), 'musée') or contains(lower-case($situationActuelle), 'MNC') or contains($situationActuelle, 'vat prah kev')">
						<xsl:value-of select="$situationActuelle"/>
					</xsl:when>
					<xsl:when test="starts-with($situationActuelle, 'DCA')">
						<xsl:value-of select="substring-after($situationActuelle, 'DCA')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>[to be completed]</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="filename" select="concat($prefid, $id, $extension, $indice, $langue2, $pos)"/>
			<xsl:if test="preceding-sibling::node()"/>
			<xsl:result-document method="xml" href="{$folder}/{$filename}.xml">
				<xsl:text>&#xa;</xsl:text>
				<xsl:processing-instruction name="xml-model">
<xsl:attribute name="href"><xsl:text>http://www.stoa.org/epidoc/schema/latest/tei-epidoc.rng</xsl:text></xsl:attribute>
<xsl:attribute name="schematypens"><xsl:text>http://relaxng.org/ns/structure/1.0</xsl:text></xsl:attribute>
</xsl:processing-instruction>
				<xsl:text>&#xa;</xsl:text>
				<xsl:processing-instruction name="xml-model">
<xsl:attribute name="href"><xsl:text>http://www.stoa.org/epidoc/schema/latest/tei-epidoc.rng</xsl:text></xsl:attribute>
<xsl:attribute name="schematypens"><xsl:text>http://purl.oclc.org/dsdl/schematron</xsl:text></xsl:attribute>
</xsl:processing-instruction>
				<xsl:text>&#xa;</xsl:text>
				<xsl:comment>
					<xsl:text>&#xa;</xsl:text>
					<xsl:text>Data from JEDS inventory: </xsl:text>
					<xsl:text>&#xa;- - - - - - - - - &#xa;</xsl:text>
					<xsl:for-each select="cell">
						<xsl:variable name="cell" select="."/>
						<xsl:for-each select="key('source', @n)">
							<xsl:value-of select="concat('[', @n, '] ')"/>
							<xsl:value-of select="text()"/>
							<xsl:text> : </xsl:text>
							<xsl:value-of select="$cell"/>
							<xsl:text>&#xa;</xsl:text>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:comment>
				<TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="en">
					<teiHeader>
						<fileDesc>
							<titleStmt>
								<title>
									<xsl:value-of select="$id_read"/>
									<xsl:comment> [to be completed] </xsl:comment>
								</title>
							</titleStmt>
							<publicationStmt>
								<authority>Visible Words 2016</authority>
								<idno type="filename">
									<xsl:value-of select="concat($filename, '.xml')"/>
								</idno>
								<availability>
									<licence>
										<p>
											<xsl:comment> copyright and licence information here </xsl:comment>
										</p>
									</licence>
								</availability>
							</publicationStmt>
							<sourceDesc>
								<msDesc>
									<msIdentifier>
										<repository>
											<xsl:comment> museum/archive </xsl:comment>
											<xsl:text>&#xa;</xsl:text>
											<xsl:value-of select="$repo"/>
										</repository>
										<idno>
											<xsl:value-of select="$id_read"/>
										</idno>
										<xsl:if test="not(cell[@n = 4] = '-')">
											<altIdentifier>
												<idno>
													<xsl:value-of select="cell[@n = 4]"/>
												</idno>
											</altIdentifier>
										</xsl:if>
									</msIdentifier>
									<physDesc>
										<objectDesc>
											<supportDesc>
												<support>
													<xsl:comment> description of object/monument (likely to include &lt;material/&gt; and &lt;objectType/&gt; information, &lt;dimensions/&gt;, etc.) </xsl:comment>
													<xsl:element name="p">
														<xsl:value-of select="cell[@n = 9]"/>
														<xsl:if test="not(cell[@n = '10'] = '')">
															<xsl:text> ; </xsl:text>
															<xsl:value-of select="cell[@n = 10]"/>
														</xsl:if>
														<xsl:if test="not(cell[@n = '11'] = '')">
															<xsl:text> ; </xsl:text>
															<xsl:value-of select="cell[@n = 11]"/>
														</xsl:if>
													</xsl:element>
												</support>
											</supportDesc>
											<layoutDesc>
												<xsl:comment> &lt;layout&gt;description of text field/campus&lt;/layout&gt; </xsl:comment>
												<layout>
													<xsl:value-of select="cell[@n = 12]"/>
												</layout>
											</layoutDesc>
										</objectDesc>
										<handDesc>
											<handNote>
												<xsl:comment> description of letters, possibly including &lt;height&gt;letter-heights&lt;/height&gt; </xsl:comment>
											</handNote>
										</handDesc>
										<decoDesc>
											<decoNote>
												<xsl:comment> description of decoration or iconography </xsl:comment>
											</decoNote>
										</decoDesc>
									</physDesc>
									<history>
										<origin>
											<origPlace>
												<xsl:value-of select="normalize-space(cell[@n = 7])"/>
											</origPlace>
											<origDate type="śaka">
												<xsl:value-of select="normalize-space(cell[@n = 14])"/>
											</origDate>
										</origin>
										<provenance type="found">
											<xsl:comment> Findspot and circumstances/context </xsl:comment>
											<xsl:choose>
												<xsl:when test="contains(cell[@n = 10], 'Trouvée')">
													<xsl:value-of select="normalize-space(cell[@n = 10])"/>
												</xsl:when>
												<xsl:when test="contains(cell[@n = 10], 'non retrouvée')">
													<provenance type="not-observed">
														<xsl:value-of select="normalize-space(cell[@n = 10])"/>
													</provenance>
												</xsl:when>
												<xsl:otherwise>
													<xsl:comment> [to be completed] </xsl:comment>
												</xsl:otherwise>
											</xsl:choose>
										</provenance>
										<provenance type="observed">
											<xsl:comment> Modern location(s) (if different from repository, above); is used to encode information about subsequent modern observation </xsl:comment>
											<xsl:text>&#xa;</xsl:text>
											<xsl:choose>
												<xsl:when test="contains(lower-case($situationActuelle), 'in situ')">
													<xsl:value-of select="normalize-space($situationActuelle)"/>
												</xsl:when>
												<xsl:when test="not($repo = '')">
													<xsl:value-of select="normalize-space($situationActuelle)"/>
												</xsl:when>
											</xsl:choose>
										</provenance>
										<provenance type="not-observed">
											<xsl:comment> information about a specific, unsuccessful attempt to locate an object in a presumed or previously recorded location </xsl:comment>
										</provenance>
										<provenance type="transferred">
											<xsl:comment> information about documentable modern relocations of the text-bearing object </xsl:comment>
										</provenance>
									</history>
									<additional>
										<surrogates>
											<xsl:if test="not(cell[@n = '15'] = '-')">
												<msDesc>
													<msIdentifier>
														<repository>EFEO</repository>
														<idno>
															<xsl:value-of select="cell[@n = 15]"/>
														</idno>
													</msIdentifier>
												</msDesc>
											</xsl:if>
											<xsl:if test="not(cell[@n = '16'] = '-')">
												<msDesc>
													<msIdentifier>
														<repository>BNF</repository>
														<idno>
															<xsl:value-of select="cell[@n = 16]"/>
														</idno>
													</msIdentifier>
												</msDesc>
											</xsl:if>
											<xsl:if test="not(cell[@n = '17'] = '-')">
												<msDesc>
													<msIdentifier>
														<repository>Autre</repository>
														<idno>
															<xsl:value-of select="cell[@n = 17]"/>
														</idno>
													</msIdentifier>
												</msDesc>
											</xsl:if>
										</surrogates>
									</additional>
									<msPart>
										<msIdentifier/>
										<physDesc/>
										<history/>
									</msPart>
								</msDesc>
							</sourceDesc>
						</fileDesc>
						<profileDesc>
							<langUsage>
								<language ident="en">
									<xsl:text>English</xsl:text>
								</language>
								<xsl:comment><xsl:value-of select="cell[@n = 13]"/></xsl:comment>
								<xsl:comment>

								&lt;language&gt;
																	
								 &lt;language ident="sa-Latn-x-CI"&gt;Sanskrit language, transliterated into Roman script
               according to the conventions of the project Corpus of the Inscriptions of
               Campā.&lt;/language&gt;
								&lt;/language&gt;
								</xsl:comment>
							</langUsage>
							<textClass>
								<keywords>
									<term>
										<xsl:comment>each keyword in a &lt;term/&gt; element </xsl:comment>
									</term>
								</keywords>
							</textClass>
						</profileDesc>
						<encodingDesc>
							<ab>
								<xsl:comment> description of encoding (version of the Epidoc version used </xsl:comment>
							</ab>
						</encodingDesc>
					</teiHeader>
					<facsimile>
						<graphic url="photograph of text or monument">
							<desc>
								<xsl:value-of select="cell[@n = 19]"/>
							</desc>
						</graphic>
					</facsimile>
					<text>
						<body>
							<div type="edition">
								<ab>
									<xsl:comment> text here </xsl:comment>
								</ab>
							</div>
							<div type="apparatus">
								<p>
									<xsl:comment> external apparatus criticus (if applicable) </xsl:comment>
								</p>
							</div>
							<div type="translation">
								<p>
									<xsl:comment> translation(s) </xsl:comment>
								</p>
							</div>
							<div type="commentary">
								<p>
									<xsl:comment> commentary </xsl:comment>
								</p>
							</div>
							<div type="bibliography">
								<xsl:comment> bibliography of previous editions, discussion, etc.</xsl:comment>
								<xsl:text>&#xa;</xsl:text>
								<xsl:variable name="biblio">
									<xsl:value-of select="concat(cell[@n = '27'], cell[@n = '28'], cell[@n = '29'], cell[@n = '30'])"/>
								</xsl:variable>
								<xsl:if test="not((cell[@n = '27'] = '') or (cell[@n = '28'] = ''))">
									<listBibl>
										<xsl:for-each select="cell[@n &gt; 26 and @n &lt; 33]">
											<xsl:variable name="refBibl">
												<xsl:apply-templates select="."/>
											</xsl:variable>
											<bibl>
												<xsl:value-of select="normalize-space($refBibl)"/>
											</bibl>
										</xsl:for-each>
									</listBibl>
								</xsl:if>
							</div>
						</body>
					</text>
				</TEI>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
<!-- To define: -->
<!-- état, revoir notion "in situ", test avec zotero, test avec images
 -->
