
require 'rexml/document'
require 'constructor'
include REXML

class VisualStudioProjFileWriter 
	constructor :doc, :strict => true

	def write(io)
		@indent = 0
		@io = io
		@doc.each_element do |el|
			print_element el
		end
		lf
		@io.flush
	end

	protected
	def print_element(el)
		if el.name == 'Folder'
			print "<Folder RelPath = \"#{el.attributes['RelPath']}\" />"
			lf
		else
			print "<#{el.name}"
			if el.has_attributes?
				lf
				print_attributes el
			end

			if el.has_elements?
				if el.has_attributes?
					print '>'
				else
					put '>'
				end
				lf
				el.elements.each do |sub_el|
					indent
					print_element sub_el
					unindent
				end
				print "</#{el.name}>"
				lf
			else
				if el.has_attributes?
					print '/>'
				else
					put '/>'
				end
				lf
			end
		end
	end

	def print_attr(key)
		key = key.to_s
		if @attrs.include?(key)
			print "#{key} = \"#{@attrs[key]}\"" 
			lf
		end
	end

	def print_attributes(el)
		@attrs = el.attributes
		indent
		case el.name
		when 'CSHARP'
			print_attr :ProjectType
			print_attr :ProductVersion
			print_attr :SchemaVersion
			print_attr :ProjectGuid
		when 'Settings'
			print_attr :ApplicationIcon
			print_attr :AssemblyKeyContainerName
			print_attr :AssemblyName
			print_attr :AssemblyOriginatorKeyFile
			print_attr :DefaultClientScript
			print_attr :DefaultHTMLPageLayout
			print_attr :DefaultTargetSchema
			print_attr :DelaySign
			print_attr :OutputType
			print_attr :PreBuildEvent
			print_attr :PostBuildEvent
			print_attr :RootNamespace
			print_attr :RunPostBuildEvent
			print_attr :StartupObject
		when 'Config'
			print_attr :Name
			print_attr :AllowUnsafeBlocks
			print_attr :BaseAddress
			print_attr :CheckForOverflowUnderflow
			print_attr :ConfigurationOverrideFile
			print_attr :DefineConstants
			print_attr :DocumentationFile
			print_attr :DebugSymbols
			print_attr :FileAlignment
			print_attr :IncrementalBuild
			print_attr :NoStdLib
			print_attr :NoWarn
			print_attr :Optimize
			print_attr :OutputPath
			print_attr :RegisterForComInterop
			print_attr :RemoveIntegerChecks
			print_attr :TreatWarningsAsErrors
			print_attr :WarningLevel
		when 'Reference'
			print_attr :Name
			print_attr :Guid
			print_attr :VersionMajor
			print_attr :VersionMinor
			print_attr :Lcid
			print_attr :WrapperTool
			print_attr :AssemblyName
			print_attr :HintPath
		when 'File'
			print_attr :RelPath
			print_attr :SubType
			print_attr :DependentUpon
			print_attr :BuildAction
		end
		unindent
	end

	def print(str)
		indent_str = (' ' * @indent)
		@io.print indent_str + str
	end

	def put(str)
		@io.print str
	end

	def lf
		@io.print "\r\n"
	end

	def indent
		@indent += 4
	end

	def unindent 
		@indent -= 4
	end

end
